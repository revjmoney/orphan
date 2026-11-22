"""Pack stories15M for the FPGA: int8 weights already laid out as the engine streams them, plus the small float parts.
    py -3 tlm_pack.py <dir with stories15M.bin + tokenizer.bin> <out dir> [model name, default stories15M]
        -> <out dir>/<model>.npz (+ tokenizer.bin copied)
Layout (tlm_gemv.v): per port p (HP0, HP2), per group of 16 rows, per column: 8 bytes = rows 16g + 8p .. + 7.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import shutil
import sys

import numpy as np

from tinylm import Model, quantize_rows

CHUNK = 4096                                   # the engine's out[] holds 4096 rows: bigger matrices run in chunks


def port_streams(W8):
    rows, cols = W8.shape
    G = rows // 16
    a = W8.reshape(G, 2, 8, cols)              # group, port, lane, column
    return [np.ascontiguousarray(a[:, p].transpose(0, 2, 1)).reshape(-1).view(np.uint8) for p in range(2)]


def pack(src, out, name='stories15M'):
    m = Model(os.path.join(src, name + '.bin'))
    streams = [[], []]
    pos = 0
    table, scales = [], []
    for mname, L, W in m.matrices():
        W8, s = quantize_rows(W)
        assert W8.shape[0] % 16 == 0
        ps = port_streams(W8)
        n = len(ps[0])
        pad = (-n) % 128
        for p in range(2):
            streams[p].append(ps[p])
            streams[p].append(np.zeros(pad, np.uint8))
        table.append((pos, W8.shape[0], W8.shape[1]))
        scales.append(s)
        pos += n + pad
    port0, port1 = np.concatenate(streams[0]), np.concatenate(streams[1])
    names = ['%s.%d' % (n, L) for n, L, _ in m.matrices()]
    cls8, cls_s = quantize_rows(m.wcls)
    np.savez(os.path.join(out, name + '.npz'),
             config=np.array([m.dim, m.hidden, m.layers, m.heads, m.vocab, m.seq], np.int32),
             names=np.array(names), table=np.array(table, np.int64), scales=np.concatenate(scales),
             port0=port0, port1=port1, rms_att=m.rms_att, rms_ffn=m.rms_ffn, rms_final=m.rms_final,
             emb8=cls8, emb_s=cls_s)
    shutil.copy(os.path.join(src, 'tokenizer.bin'), out)
    print('packed %s: %d matrices, %.2f MB per port' % (name, len(names), len(port0) / 2 ** 20))


if __name__ == '__main__':
    pack(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else 'stories15M')
