"""[orphan] Orphan TinyLM: Karpathy's stories15M (llama2.c, MIT) running with the FPGA doing every matrix multiply.

The model: a 15M-parameter Llama (dim 288, 6 layers, 6 heads, FFN 768, vocab 32000, 256 tokens of context) trained
on TinyStories. Here every weight matrix is quantized to int8 with one scale per row; each activation vector to int8
with one scale. A matrix-vector product is then sum(int8 * int8) per row (exact integers, what the FPGA's 16 lanes
compute), times the two scales. Everything else (RMSNorm, RoPE, attention, SiLU, sampling) stays float on the ARM.

    matvec(W8, scale_w, x)  ->  float vector        (numpy here; TlmEngine.matvec on the board, same integers)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later (this file). Model weights + tokenizer: llama2.c by Andrej Karpathy, MIT."""
import struct

import numpy as np


# ------------------------------------------------------------------------------------------- loading
class Model:
    def __init__(self, path):
        raw = open(path, 'rb').read()
        dim, hidden, layers, heads, kv_heads, vocab, seq = struct.unpack('7i', raw[:28])
        self.shared = vocab > 0
        vocab = abs(vocab)
        self.dim, self.hidden, self.layers, self.heads, self.vocab, self.seq = dim, hidden, layers, heads, vocab, seq
        self.hs = dim // heads
        f = np.frombuffer(raw, dtype=np.float32, offset=28)
        o = 0

        def take(*shape):
            nonlocal o
            n = int(np.prod(shape))
            a = f[o:o + n].reshape(shape)
            o += n
            return a
        kv = dim * kv_heads // heads
        self.emb = take(vocab, dim)
        self.rms_att = take(layers, dim)
        self.wq, self.wk, self.wv = take(layers, dim, dim), take(layers, kv, dim), take(layers, kv, dim)
        self.wo = take(layers, dim, dim)
        self.rms_ffn = take(layers, dim)
        self.w1, self.w2, self.w3 = take(layers, hidden, dim), take(layers, dim, hidden), take(layers, hidden, dim)
        self.rms_final = take(dim)
        take(seq, self.hs // 2)                      # the old RoPE tables (computed below instead)
        take(seq, self.hs // 2)
        self.wcls = self.emb if self.shared else take(vocab, dim)
        # RoPE as in llama2.c run.c
        i = np.arange(0, self.hs, 2)
        self.freq = 1.0 / (10000.0 ** (i / self.hs))

    def matrices(self):
        """Every weight matrix in the order one token uses them: (name, layer, W)."""
        out = []
        for L in range(self.layers):
            for n in ('wq', 'wk', 'wv', 'wo', 'w1', 'w3', 'w2'):
                out.append((n, L, getattr(self, n)[L]))
        out.append(('cls', 0, self.wcls))
        return out


def quantize_rows(W):
    """int8 per row: W ~ q * s[:, None]."""
    s = np.abs(W).max(axis=1) / 127.0
    s[s == 0] = 1.0
    return np.clip(np.round(W / s[:, None]), -127, 127).astype(np.int8), s.astype(np.float32)


def quantize_vec(x):
    s = float(np.abs(x).max()) / 127.0 or 1.0
    return np.clip(np.round(x / s), -127, 127).astype(np.int8), s


# ------------------------------------------------------------------------------------------- tokenizer
class Tokenizer:
    def __init__(self, path, vocab):
        b = open(path, 'rb').read()
        self.max_len = struct.unpack_from('i', b, 0)[0]
        o, self.pieces, self.scores = 4, [], []
        for _ in range(vocab):
            sc, n = struct.unpack_from('fi', b, o)
            o += 8
            self.pieces.append(b[o:o + n])
            self.scores.append(sc)
            o += n
        self.index = {p: i for i, p in enumerate(self.pieces)}

    def decode(self, prev, tok):
        p = self.pieces[tok]
        if prev == 1 and p.startswith(b' '):
            p = p[1:]
        if p.startswith(b'<0x') and p.endswith(b'>') and len(p) == 6:
            p = bytes([int(p[3:5], 16)])
        return p.decode('utf-8', 'replace')

    def encode(self, text, bos=True):
        """llama2.c's encode: characters, then merge the best-scoring pairs until none is left."""
        toks = []
        if text:
            text = ' ' + text                        # the dummy prefix sentencepiece adds
        for ch in text:
            c = ch.encode('utf-8')
            if c in self.index:
                toks.append(self.index[c])
            else:
                toks += [b + 3 for b in c]           # byte fallback
        while True:
            best, bi = -1e10, -1
            for i in range(len(toks) - 1):
                m = self.pieces[toks[i]] + self.pieces[toks[i + 1]]
                j = self.index.get(m)
                if j is not None and self.scores[j] > best:
                    best, bi, bj = self.scores[j], i, j
            if bi < 0:
                break
            toks[bi:bi + 2] = [bj]
        return ([1] if bos else []) + toks


# ------------------------------------------------------------------------------------------- the forward pass
def rmsnorm(x, w):
    return w * (x / np.sqrt(np.mean(x * x) + 1e-5))


class Runner:
    """One token at a time with a KV cache. matvec(name, layer, x) does every matrix product."""

    def __init__(self, m, matvec):
        self.m, self.mv = m, matvec
        kv = m.dim
        self.kc = np.zeros((m.layers, m.seq, kv), np.float32)
        self.vc = np.zeros((m.layers, m.seq, kv), np.float32)

    def step(self, tok, pos):
        m, mv = self.m, self.mv
        x = m.emb[tok].astype(np.float32).copy()
        ang = pos * m.freq
        cos, sin = np.cos(ang).astype(np.float32), np.sin(ang).astype(np.float32)
        for L in range(m.layers):
            xb = rmsnorm(x, m.rms_att[L])
            q, k, v = mv('wq', L, xb), mv('wk', L, xb), mv('wv', L, xb)
            for t in (q, k):                          # RoPE on pairs (i, i + 1) inside every head
                a = t.reshape(m.heads, m.hs // 2, 2)
                r0, r1 = a[..., 0].copy(), a[..., 1].copy()
                a[..., 0] = r0 * cos - r1 * sin
                a[..., 1] = r0 * sin + r1 * cos
            self.kc[L, pos], self.vc[L, pos] = k, v
            qh = q.reshape(m.heads, m.hs)
            K = self.kc[L, :pos + 1].reshape(pos + 1, m.heads, m.hs)
            V = self.vc[L, :pos + 1].reshape(pos + 1, m.heads, m.hs)
            att = np.einsum('hd,thd->ht', qh, K) / np.sqrt(m.hs)
            att = np.exp(att - att.max(axis=1, keepdims=True))
            att /= att.sum(axis=1, keepdims=True)
            o = np.einsum('ht,thd->hd', att, V).reshape(m.dim)
            x = x + mv('wo', L, o)
            xb = rmsnorm(x, m.rms_ffn[L])
            h1, h3 = mv('w1', L, xb), mv('w3', L, xb)
            x = x + mv('w2', L, (h1 / (1.0 + np.exp(-h1))) * h3)
        return mv('cls', 0, rmsnorm(x, m.rms_final))


def float_matvec(m):
    return lambda n, L, x: (getattr(m, 'wcls' if n == 'cls' else n)[L] if n != 'cls' else m.wcls) @ x


class Int8Ref:
    """The integer math the FPGA does, in numpy: int8 rows . int8 vector -> int32, then the scales."""

    def __init__(self, m):
        self.q = {(n, L): quantize_rows(W) for n, L, W in m.matrices()}

    def __call__(self, n, L, x):
        W8, sw = self.q[(n, L)]
        x8, sx = quantize_vec(x)
        acc = W8.astype(np.int32) @ x8.astype(np.int32)
        return acc.astype(np.float32) * sw * sx


def sample(logits, temp, rng, topp=0.9):
    if temp <= 0:
        return int(np.argmax(logits))
    p = np.exp((logits - logits.max()) / temp)
    p /= p.sum()
    order = np.argsort(-p)
    cut = np.searchsorted(np.cumsum(p[order]), topp) + 1
    keep = order[:cut]
    return int(rng.choice(keep, p=p[keep] / p[keep].sum()))


def generate(m, tok, matvec, prompt='', steps=200, temp=0.8, seed=None, on_token=None):
    rng = np.random.default_rng(seed)
    r = Runner(m, matvec)
    ids = tok.encode(prompt)
    out, prev, cur = [], 1, ids[0]
    for pos in range(min(steps, m.seq)):
        logits = r.step(cur, pos)
        nxt = ids[pos + 1] if pos + 1 < len(ids) else sample(logits, temp, rng)
        if nxt == 1:                                  # BOS: the story is over
            break
        piece = tok.decode(cur, nxt)
        out.append(piece)
        if on_token:
            on_token(piece)
        prev, cur = cur, nxt
    return ''.join(out)


if __name__ == '__main__':
    import sys
    import time
    d = sys.argv[1] if len(sys.argv) > 1 else '.'
    m = Model(d + '/stories15M.bin')
    t = Tokenizer(d + '/tokenizer.bin', m.vocab)
    for name, mv in (('float32', float_matvec(m)), ('int8 (what the FPGA computes)', Int8Ref(m))):
        t0 = time.time()
        s = generate(m, t, mv, 'Once upon a time, a little robot', steps=120, temp=0.0)
        print('== %s (%.1f s)\n%s\n' % (name, time.time() - t0, s))
