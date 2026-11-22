"""Orphan TinyLM, 4 at once: the batch engine (tlm_gemv TLM4: 64 lanes = 16 rows x 4 stories, 16-bit results) and a
Llama runner with 4 slots, each its own position and KV cache. Used for "4 stories" and "4 takes per chapter".
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import json
import os
import time

import numpy as np

import tlm_board
from tinylm import quantize_vec, rmsnorm, sample

B = 4


class Engine4(tlm_board.Engine):
    """tlm_gemv TLM4: out[b] = sat16((W8 . x8_b) >> shift) for up to 4 vectors per weight pass.
    models: {name: (Packed, shifts)}; all of them sit in one locked DDR store (16384 pages = 64 MB), so switching
    between them (select) is instant."""

    def __init__(self, models):
        tlm_board.set_hp0_64bit()
        self.bus = tlm_board.Bus()
        tlm_board.require(self.bus, 'TLM4')
        mm = self.bus.m
        self.w = mm._w
        self.base = (mm._off >> 2) + tlm_board.SLOT * 1024
        self.wnp = np.frombuffer(mm._m, dtype=np.uint32)
        self.popv = np.full(tlm_board.CHUNK, self.base + 768)
        self.models, self.offset, o = {}, {}, 0
        for name, (m, sh) in models.items():
            self.models[name] = (m, sh)
            self.offset[name] = o
            o += (len(m.port0) + 4095) // 4096 * 4096
        region = o
        if 2 * region > 16384 * 4096:
            raise ValueError('the models do not fit the 64 MB page table')
        self.store = tlm_board.DDRStore(region=region, ports=2)
        for name, (m, sh) in models.items():
            a, n = self.offset[name], len(m.port0)
            self.store.a[a:a + n] = m.port0
            self.store.a[region + a:region + a + n] = m.port1
        self.store.flush()
        self.wr(6, region)
        self.wr(7, 0)
        for pg in self.store.pages:
            self.wr(8, pg)
        self.region = region
        self.fpga_s, self.calls = 0.0, 0
        self.select(next(iter(models)))

    def select(self, name):
        self.name = name
        self.m, self.shifts = self.models[name]
        self.ofs = self.offset[name]

    def write_x(self, b, xb):
        """Story b's x (int8 bytes, a multiple of 4) into the engine, 256 words per window position."""
        self.wr(18, b)
        words = memoryview(xb.tobytes()).cast('I')
        for k in range(0, len(words), 256):
            self.wr(20, k)
            seg = words[k:k + 256]
            self.w[self.base + 512:self.base + 512 + len(seg)] = seg

    def batch(self, name, L, X):
        """X: (n, cols) float, n = 1..4 -> (n, rows) float."""
        key = '%s.%d' % (name, L)
        pos, rows, cols = self.m.table[key]
        pos += self.ofs
        n = X.shape[0]
        sx = np.empty(n, np.float32)
        for b in range(n):
            x8, sx[b] = quantize_vec(X[b])
            xb = np.zeros((cols + 3) // 4 * 4, np.int8)
            xb[:cols] = x8
            self.write_x(b, xb)
        sh = self.shifts[key]
        self.wr(19, sh)
        self.wr(3, cols)
        out = np.empty((n, rows), np.float32)
        t0 = time.perf_counter()
        for r0 in range(0, rows, tlm_board.CHUNK):
            rr = min(tlm_board.CHUNK, rows - r0)
            nb = rr // 16 * cols * 8
            self.wr(4, pos + r0 // 16 * cols * 8)
            self.wr(5, (nb + 127) // 128 * 128)
            self.wr(2, rr)
            self.wr(0, 1)
            while not self.rd(1) & 2:
                pass
            self.wr(9, 0)
            a = self.wnp[self.popv[:rr]].view(np.int16).reshape(rr, 2)       # stories 0, 1
            out[:min(n, 2), r0:r0 + rr] = a[:, :min(n, 2)].T
            if n > 2:
                self.wr(9, 4096)
                c = self.wnp[self.popv[:rr]].view(np.int16).reshape(rr, 2)   # stories 2, 3
                out[2:n, r0:r0 + rr] = c[:, :n - 2].T
        self.fpga_s += time.perf_counter() - t0
        self.calls += 1
        return out * (float(1 << sh)) * self.m.scales[key][None, :] * sx[:, None]


class Runner4:
    """4 slots, each its own position and KV cache; one FPGA weight pass serves all of them."""

    def __init__(self, m, eng):
        self.m, self.e = m, eng
        self.kc = np.zeros((B, m.layers, m.ctx, m.dim), np.float32)
        self.vc = np.zeros((B, m.layers, m.ctx, m.dim), np.float32)

    def copy_slot(self, src, upto):
        for b in range(B):
            if b != src:
                self.kc[b, :, :upto] = self.kc[src, :, :upto]
                self.vc[b, :, :upto] = self.vc[src, :, :upto]

    def step(self, toks, poss):
        m, mv, n = self.m, self.e.batch, len(toks)
        x = np.stack([m.emb[t] for t in toks]).astype(np.float32)
        ang = np.asarray(poss, np.float32)[:, None] * m.freq[None, :]
        cos, sin = np.cos(ang), np.sin(ang)                       # (n, hs/2)
        for L in range(m.layers):
            xb = np.stack([rmsnorm(x[b], m.rms_att[L]) for b in range(n)])
            q, k, v = mv('wq', L, xb), mv('wk', L, xb), mv('wv', L, xb)
            for t in (q, k):
                a = t.reshape(n, m.heads, m.hs // 2, 2)
                r0, r1 = a[..., 0].copy(), a[..., 1].copy()
                a[..., 0] = r0 * cos[:, None, :] - r1 * sin[:, None, :]
                a[..., 1] = r0 * sin[:, None, :] + r1 * cos[:, None, :]
            o = np.empty((n, m.dim), np.float32)
            for b in range(n):
                p = poss[b]
                self.kc[b, L, p], self.vc[b, L, p] = k[b], v[b]
                qh = q[b].reshape(m.heads, m.hs)
                K = self.kc[b, L, :p + 1].reshape(p + 1, m.heads, m.hs)
                V = self.vc[b, L, :p + 1].reshape(p + 1, m.heads, m.hs)
                att = np.einsum('hd,thd->ht', qh, K) / np.sqrt(m.hs)
                att = np.exp(att - att.max(axis=1, keepdims=True))
                att /= att.sum(axis=1, keepdims=True)
                o[b] = np.einsum('ht,thd->hd', att, V).reshape(m.dim)
            x = x + mv('wo', L, o)
            xb = np.stack([rmsnorm(x[b], m.rms_ffn[L]) for b in range(n)])
            h1, h3 = mv('w1', L, xb), mv('w3', L, xb)
            x = x + mv('w2', L, (h1 / (1.0 + np.exp(-h1))) * h3)
        return mv('cls', 0, np.stack([rmsnorm(x[b], m.rms_final) for b in range(n)]))


def fast_sample(logits, temp, rng, topp=0.9):
    """sample() without sorting all 32000: the top 64 hold the top-p mass of a TinyStories model."""
    if temp <= 0:
        return int(np.argmax(logits))
    top = np.argpartition(-logits, 64)[:64]
    return int(top[sample(logits[top], temp, rng, topp)])


CTX = {'stories15M': 256, 'stories42M': 384}           # story memory (KV cache) per model, to keep RAM in check


def load_models(here):
    """Every packed model in model/ (<name>.npz + <name>.shifts.json): {name: (Packed, shifts)}, smallest first."""
    out = {}
    names = sorted((f[:-4] for f in os.listdir(os.path.join(here, 'model')) if f.endswith('.npz')),
                   key=lambda n: os.path.getsize(os.path.join(here, 'model', n + '.npz')))
    for n in names:
        m = tlm_board.Packed(os.path.join(here, 'model', n + '.npz'))
        m.ctx = min(m.seq, CTX.get(n, 256))
        m.seq = m.ctx
        out[n] = (m, json.load(open(os.path.join(here, 'model', n + '.shifts.json'))))
    return out
