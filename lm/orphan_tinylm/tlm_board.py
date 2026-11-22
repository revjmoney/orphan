"""Orphan TinyLM on the board: the packed model in locked DDR, every matrix product on the FPGA (tlm_gemv),
the rest of the Llama on the ARM (numpy). Also an ARM-only path with the same int8 numbers, for the race.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later. DDRStore is Ardzy's (blocks.py, project 19, by chryso, GPL-3.0)."""
import time

import numpy as np

from blocks import Bus, DDRStore, require
from tinylm import Runner, Tokenizer, quantize_vec, sample

SLOT = 1
REGION = 8 << 20                                  # bytes per HP port region (4096 pages = 16 MB in all)
CHUNK = 4096


class Packed:
    """The model parts the ARM needs (norms, the embedding as int8 + scales) and the matrix table."""

    def __init__(self, path):
        z = np.load(path)
        self.dim, self.hidden, self.layers, self.heads, self.vocab, self.seq = [int(v) for v in z['config']]
        self.hs = self.dim // self.heads
        self.rms_att, self.rms_ffn, self.rms_final = z['rms_att'], z['rms_ffn'], z['rms_final']
        self.emb8, self.emb_s = z['emb8'], z['emb_s']
        self.emb = _Emb(self)
        i = np.arange(0, self.hs, 2)
        self.freq = 1.0 / (10000.0 ** (i / self.hs))
        self.names = [str(n) for n in z['names']]
        self.table = {n: tuple(int(v) for v in t) for n, t in zip(self.names, z['table'])}
        sc, o = z['scales'], 0
        self.scales = {}
        for n in self.names:
            r = self.table[n][1]
            self.scales[n] = sc[o:o + r]
            o += r
        self.port0, self.port1 = z['port0'], z['port1']


class _Emb:
    """m.emb[tok] for the Runner: the token's row of the (shared) int8 table, back to float."""

    def __init__(self, m):
        self.m = m

    def __getitem__(self, tok):
        return self.m.emb8[tok].astype(np.float32) * self.m.emb_s[tok]


def set_hp0_64bit():
    """The S9's boot firmware leaves the PS's HP0 port in 32-bit mode (AFI RDCHAN_CTRL bit 0): the upper half of every
    64-bit word then reads 0. Switch HP0's read and write channels to 64-bit (one 32-bit access each: this register
    block faults on byte access)."""
    import mmap
    import os
    f = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
    try:
        m = mmap.mmap(f, 4096, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=0xF8008000)
        r = memoryview(m).cast('I')
        for i in (0, 5):                           # RDCHAN_CTRL (0x00), WRCHAN_CTRL (0x14)
            r[i] = r[i] & ~1
        r.release()
        m.close()
    finally:
        os.close(f)


class Engine:
    """tlm_gemv: out = W8 . x8 on the FPGA, its weights already in the locked DDR store."""

    def __init__(self, model):
        set_hp0_64bit()
        self.bus = Bus()
        require(self.bus, 'TLM1')
        self.m = model
        mm = self.bus.m
        self.w = mm._w
        self.base = (mm._off >> 2) + SLOT * 1024
        self.wnp = np.frombuffer(mm._m, dtype=np.uint32)
        self.popv = np.full(CHUNK, self.base + 768)
        self.store = DDRStore(region=REGION, ports=2)
        n = len(model.port0)
        self.store.a[0:n] = model.port0
        self.store.a[REGION:REGION + n] = model.port1
        self.store.flush()
        self.wr(6, REGION)
        self.wr(7, 0)
        for pg in self.store.pages:
            self.wr(8, pg)
        self.fpga_s, self.calls, self.stalls = 0.0, 0, 0

    def wr(self, i, v):
        self.w[self.base + i] = int(v) & 0xFFFFFFFF

    def rd(self, i):
        return self.w[self.base + i]

    def __call__(self, name, L, x):
        key = '%s.%d' % (name, L)
        pos, rows, cols = self.m.table[key]
        x8, sx = quantize_vec(x)
        xb = np.zeros((cols + 3) // 4 * 4, np.int8)
        xb[:cols] = x8
        words = xb.view(np.uint32)
        self.w[self.base + 512:self.base + 512 + len(words)] = memoryview(words.tobytes()).cast("I")
        self.wr(3, cols)
        out = np.empty(rows, np.int32)
        t0 = time.perf_counter()
        for r0 in range(0, rows, CHUNK):
            rr = min(CHUNK, rows - r0)
            n = rr // 16 * cols * 8
            self.wr(4, pos + r0 // 16 * cols * 8)
            self.wr(5, (n + 127) // 128 * 128)
            self.wr(2, rr)
            self.wr(0, 1)
            while not self.rd(1) & 2:
                pass
            self.stalls += self.rd(11)
            self.wr(9, 0)
            # read the pop address over and over (single 32-bit loads): block copies become AXI burst reads,
            # and those come back scrambled through the bus bridge at 75 MHz
            out[r0:r0 + rr] = self.wnp[self.popv[:rr]].view(np.int32)
        self.fpga_s += time.perf_counter() - t0
        self.calls += 1
        return out.astype(np.float32) * self.m.scales[key] * sx


class ArmInt8:
    """The same int8 numbers on the ARM alone (numpy), to race the FPGA."""

    def __init__(self, model):
        self.m, self.W = model, {}
        for key in model.names:
            pos, rows, cols = model.table[key]
            G, n = rows // 16, rows // 16 * cols * 8
            a = np.stack([model.port0[pos:pos + n].view(np.int8).reshape(G, cols, 8),
                          model.port1[pos:pos + n].view(np.int8).reshape(G, cols, 8)], axis=1)
            # float32 holds these integer sums exactly (|sum| <= 768 * 127 * 127 < 2^24): the same numbers as the
            # FPGA, at numpy's (BLAS) best speed on the ARM, a fair race
            self.W[key] = np.ascontiguousarray(a.transpose(0, 1, 3, 2).reshape(rows, cols)).astype(np.float32)

    def __call__(self, name, L, x):
        key = '%s.%d' % (name, L)
        x8, sx = quantize_vec(x)
        acc = self.W[key] @ x8.astype(np.float32)
        return acc * self.m.scales[key] * sx


def self_check(model, eng, keys=('wq.0', 'w1.3', 'w2.5', 'cls.0')):
    """FPGA vs the exact int8 sums on the ARM for a few real matrices: returns [(key, max |diff|, fpga ms)]."""
    rng = np.random.default_rng(7)
    out = []
    for key in keys:
        name, L = key.split('.')
        pos, rows, cols = model.table[key]
        G, n = rows // 16, rows // 16 * cols * 8
        a = np.stack([model.port0[pos:pos + n].view(np.int8).reshape(G, cols, 8),
                      model.port1[pos:pos + n].view(np.int8).reshape(G, cols, 8)], axis=1)
        W = a.transpose(0, 1, 3, 2).reshape(rows, cols).astype(np.float32)
        x = rng.standard_normal(cols).astype(np.float32)
        x8, sx = quantize_vec(x)
        want = (W @ x8.astype(np.float32)) * model.scales[key] * sx
        t0 = time.perf_counter()
        got = eng(name, int(L), x)
        ms = (time.perf_counter() - t0) * 1000
        out.append((key, float(np.abs(got - want).max()), round(ms, 2)))
    return out


def stream(m, tok, matvec, prompt, steps, temp, seed, on_piece, stop=lambda: False):
    """Generate token by token; on_piece(text, tokens, seconds) after each one."""
    rng = np.random.default_rng(seed)
    r = Runner(m, matvec)
    ids = tok.encode(prompt)
    cur, t0, n = ids[0], time.perf_counter(), 0
    for pos in range(min(steps, m.seq)):
        if stop():
            break
        logits = r.step(cur, pos)
        nxt = ids[pos + 1] if pos + 1 < len(ids) else sample(logits, temp, rng)
        if nxt == 1:
            break
        n += 1
        on_piece(tok.decode(cur, nxt), n, time.perf_counter() - t0)
        cur = nxt
