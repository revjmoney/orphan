"""MIMIK chip model: TF-Luna. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

import time


def setup(chip):
    chip.ro(0, 8)


def update(chip, v):
    d = max(0, min(0xFFFF, round(v['distance'])))
    a = max(0, min(0xFFFF, round(v['amp'])))
    t = max(0, min(0xFFFF, round(v['temp'] * 100)))
    k = int(time.monotonic() * 1000) & 0xFFFF
    chip.put(0, [d & 0xFF, d >> 8, a & 0xFF, a >> 8, t & 0xFF, t >> 8, k & 0xFF, k >> 8])
