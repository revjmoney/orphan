"""Pick a right-shift per matrix so the batch engine's 16-bit results fit, then check the stories still read well.
    py -3 tlm_calib.py <dir with stories15M.bin + tokenizer.bin>  -> shifts.json
The batch engine returns sat16(acc >> shift) per row; the ARM multiplies back by 2^shift.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import json
import sys

import numpy as np

from tinylm import Model, Tokenizer, generate, quantize_rows, quantize_vec

src = sys.argv[1]
NAME = sys.argv[2] if len(sys.argv) > 2 else 'stories15M'
m = Model(src + '/' + NAME + '.bin')
tok = Tokenizer(src + '/tokenizer.bin', m.vocab)
Q = {(n, L): quantize_rows(W) for n, L, W in m.matrices()}
peak = {}


def mv_record(n, L, x):
    W8, sw = Q[(n, L)]
    x8, sx = quantize_vec(x)
    acc = W8.astype(np.int32) @ x8.astype(np.int32)
    k = '%s.%d' % (n, L)
    peak[k] = max(peak.get(k, 0), int(np.abs(acc).max()))
    return acc.astype(np.float32) * sw * sx


for p in ('Once upon a time, a little robot', 'The dragon found a shiny stone', 'Tom and his dog went to the park',
          'There was a tiny mouse who', 'One day, Lily'):
    generate(m, tok, mv_record, p, steps=120, temp=0.9, seed=1)
shifts = {k: max(0, int(np.ceil(np.log2(v * 1.5 / 32767)))) for k, v in peak.items()}
print('shifts:', sorted(set(shifts.values())), ' e.g.', {k: shifts[k] for k in list(shifts)[:8]}, 'cls', shifts['cls.0'])


def mv_16(n, L, x):
    W8, sw = Q[(n, L)]
    x8, sx = quantize_vec(x)
    acc = W8.astype(np.int32) @ x8.astype(np.int32)
    s = shifts['%s.%d' % (n, L)]
    q = np.clip(acc >> s, -32768, 32767).astype(np.int32) << s
    return q.astype(np.float32) * sw * sx


for p in ('Once upon a time, a little robot', 'The dragon found a shiny stone'):
    print('== int16 results:', generate(m, tok, mv_16, p, steps=90, temp=0.0)[:400], '\n')
json.dump(shifts, open('model/' + NAME + '.shifts.json', 'w'), indent=1)
print('wrote model/%s.shifts.json' % NAME)
