# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""Save what the ORPHAN Remote shows right now as a PNG:  py -3 tools/cyd_screenshot.py <cyd ip> out.png
(GET /screen gives 320 x 240 RGB565 read back from the panel.) by JMSCNC, makers of RotatoCAM."""
import sys
import urllib.request

import numpy as np
from PIL import Image

raw = urllib.request.urlopen('http://%s/screen' % sys.argv[1], timeout=10).read()
p = np.frombuffer(raw, dtype='<u2').reshape(240, 320).astype(np.uint32)
rgb = np.stack([(p >> 11 & 31) * 255 // 31, (p >> 5 & 63) * 255 // 63, (p & 31) * 255 // 31], axis=2).astype(np.uint8)
Image.fromarray(rgb).save(sys.argv[2])
print('saved', sys.argv[2], len(raw), 'bytes')
