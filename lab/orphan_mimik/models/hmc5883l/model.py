"""MIMIK chip model: HMC5883L. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

import math

GAIN = [1370, 1090, 820, 660, 440, 390, 330, 230]     # counts per gauss for CRB bits 7..5


def setup(chip):
    chip.put(0, [0x10, 0x20, 0x01, 0, 0, 0, 0, 0, 0, 1, ord('H'), ord('4'), ord('3')])
    chip.ro(3, 10)


def clamp(v):
    v = round(v)
    return (-4096 if v < -2048 or v > 2047 else v) & 0xFFFF            # the chip reports an overflow as -4096


def update(chip, v):
    g = GAIN[chip.get(1)[0] >> 5]
    h = v['field'] * math.cos(math.radians(v['dip']))
    x = clamp(g * h * math.cos(math.radians(v['heading'])))
    y = clamp(g * h * math.sin(math.radians(v['heading'])))
    z = clamp(g * v['field'] * math.sin(math.radians(v['dip'])))
    chip.put(3, [x >> 8, x & 0xFF, z >> 8, z & 0xFF, y >> 8, y & 0xFF])
