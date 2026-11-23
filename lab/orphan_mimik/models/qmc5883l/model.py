"""MIMIK chip model: QMC5883L. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

import math


def setup(chip):
    chip.put(0, [0] * 6 + [1, 0, 0, 0, 0, 0, 0, 0xFF])
    chip.ro(0, 9)
    chip.ro(0x0D)


def s16(v):
    return max(-32768, min(32767, round(v))) & 0xFFFF


def update(chip, v):
    g = 3000 if (chip.get(9)[0] >> 4) & 3 == 1 else 12000
    h = v['field'] * math.cos(math.radians(v['dip']))
    x = s16(g * h * math.cos(math.radians(v['heading'])))
    y = s16(g * h * math.sin(math.radians(v['heading'])))
    z = s16(g * v['field'] * math.sin(math.radians(v['dip'])))
    chip.put(0, [x & 0xFF, x >> 8, y & 0xFF, y >> 8, z & 0xFF, z >> 8, 1])
