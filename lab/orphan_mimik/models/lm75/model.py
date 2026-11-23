"""MIMIK chip model: LM75. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

def setup(chip):
    chip.put(0, [0, 0, 0x00, 0x00, 0x4B, 0x00, 0x50, 0x00])
    chip.ro(0, 2)


def update(chip, v):
    raw = (max(-256, min(255, round(v['temp'] * 2))) & 0x1FF) << 7
    chip.put(0, [raw >> 8, raw & 0xFF])
