"""Debug tlm_gemv against the exact int8 sums.
    python3 tlm_debug.py [map]      (stop the app first: systemctl stop ardzy-app)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import sys

import numpy as np

import tlm_board

HERE = os.path.dirname(os.path.abspath(__file__))
m = tlm_board.Packed(os.path.join(HERE, 'model', 'tinylm_q8.npz'))
e = tlm_board.Engine(m)


def W_of(key):
    pos, rows, cols = m.table[key]
    G, n = rows // 16, rows // 16 * cols * 8
    a = np.stack([m.port0[pos:pos + n].view(np.int8).reshape(G, cols, 8),
                  m.port1[pos:pos + n].view(np.int8).reshape(G, cols, 8)], axis=1)
    return a.transpose(0, 1, 3, 2).reshape(rows, cols).astype(np.int32)


def raw(key, x8, verbose=False):
    pos, rows, cols = m.table[key]
    xb = np.zeros((cols + 3) // 4 * 4, np.int8)
    xb[:cols] = x8
    w = xb.view(np.uint32)
    e.w[e.base + 512:e.base + 512 + len(w)] = memoryview(w.tobytes()).cast('I')
    e.wr(3, cols)
    n = rows // 16 * cols * 8
    e.wr(4, pos)
    e.wr(5, (n + 127) // 128 * 128)
    e.wr(2, rows)
    e.wr(0, 1)
    while not e.rd(1) & 2:
        pass
    if verbose:
        print('   cycles %d stalls %d errors %d' % (e.rd(10), e.rd(11), e.rd(12)))
    e.wr(9, 0)
    out = []
    for k in range(0, rows, 256):
        c = min(256, rows - k)
        out.append(np.frombuffer(e.w[e.base + 768:e.base + 768 + c].tobytes(), np.int32))
    return np.concatenate(out)


if __name__ == '__main__':
    key = 'wq.0'
    W = W_of(key)
    rows, cols = W.shape
    G = np.zeros((rows, cols), np.int32)
    for k in range(cols):
        x = np.zeros(cols, np.int8)
        x[k] = 1
        G[:, k] = raw(key, x)
    # what each output row really computed: which W row, with which column shift
    for r in list(range(18)) + [100, 287]:
        found = []
        for rr in range(rows):
            for s in range(-3, 4):
                a = G[r, max(0, s):cols + min(0, s)]
                b = W[rr, max(0, -s):cols + min(0, -s)]
                if (a == b).mean() > 0.95:
                    found.append((rr, s))
        print('out row %3d (lane %2d) = (W row, shift) %s' % (r, r % 16, found[:3]))
    x = np.random.default_rng(3).integers(-127, 128, cols).astype(np.int8)
    got, want = raw(key, x, True), W @ x.astype(np.int32)
    print('random x: %d/%d rows wrong' % (int((got != want).sum()), rows))
