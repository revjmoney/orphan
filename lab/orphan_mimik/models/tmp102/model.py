"""MIMIK chip model: TMP102. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

def setup(chip):
    chip.put(0, [0, 0, 0x60, 0xA0, 0x4B, 0x00, 0x50, 0x00])
    chip.ro(0, 2)


def update(chip, v):
    raw = (max(-2048, min(2047, round(v['temp'] / 0.0625))) & 0xFFF) << 4
    chip.put(0, [raw >> 8, raw & 0xFF])
