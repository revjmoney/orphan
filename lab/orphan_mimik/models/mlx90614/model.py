"""MIMIK chip model: MLX90614. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

def pec(data):
    c = 0
    for b in data:
        c ^= b
        for _ in range(8):
            c = ((c << 1) ^ 0x07) & 0xFF if c & 0x80 else (c << 1) & 0xFF
    return c


def word(chip, cmd, temp_c):
    raw = max(0, min(0x7FFF, round((temp_c + 273.15) / 0.02)))
    a = int(str(chip.model['config']['address']), 0)
    lo, hi = raw & 0xFF, raw >> 8
    chip.put(cmd * 4, [lo, hi, pec([a << 1, cmd, (a << 1) | 1, lo, hi])])


def setup(chip):
    for cmd in (0x06, 0x07, 0x08):
        chip.ro(cmd * 4, 4)


def update(chip, v):
    word(chip, 0x06, v['ambient'])
    word(chip, 0x07, v['object'])
    word(chip, 0x08, v['object'])
