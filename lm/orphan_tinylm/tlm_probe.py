"""Which stream byte does each lane take? A synthetic matrix in spare DDR: byte b of word c on port p holds
1 + b + 8p + 16 * (c % 7). With x one-hot at column k, lane l returns exactly the byte it multiplied.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import numpy as np

import tlm_debug as d

e = d.e
OFS = 7680 * 1024                                    # spare space after the model (7.24 MB) in both regions
COLS = 64
for p in range(2):
    words = np.zeros((COLS, 8), np.int8)
    for c in range(COLS):
        for b in range(8):
            words[c, b] = 1 + b + 8 * p + 16 * (c % 7)
    e.store.a[p * d.tlm_board.REGION + OFS:p * d.tlm_board.REGION + OFS + COLS * 8] = words.reshape(-1).view(np.uint8)
e.store.flush()
d.m.table['probe'] = (OFS, 16, COLS)
for k in (0, 1, 2, 3, 10):
    x = np.zeros(COLS, np.int8)
    x[k] = 1
    got = d.raw('probe', x, True)
    dec = ['p%d b%d c%d' % ((v - 1) // 8 % 2, (v - 1) % 8, (v - 1) // 16) if v > 0 else '-' for v in got]
    print('x one-hot col %2d (c%%7=%d):' % (k, k % 7), ' | '.join('L%d %s' % (i, s) for i, s in enumerate(dec)))
