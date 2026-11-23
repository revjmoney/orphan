"""MIMIK chip model: BH1750. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

MODES = {0x10: 1.2, 0x13: 1.2, 0x20: 1.2, 0x23: 1.2, 0x11: 2.4, 0x21: 2.4}


def setup(chip):
    for c in MODES:
        chip.ro(c * 2, 2)


def update(chip, v):
    for c, k in MODES.items():
        n = max(0, min(0xFFFF, round(v['lux'] * k)))
        chip.put(c * 2, [n >> 8, n & 0xFF])
