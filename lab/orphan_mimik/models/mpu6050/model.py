"""MIMIK chip model: MPU-6050. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

ACC = [16384, 8192, 4096, 2048]
GYR = [131, 65.5, 32.8, 16.4]


def setup(chip):
    chip.put(0x6B, [0x40])
    chip.put(0x75, [0x68])
    chip.ro(0x3B, 14)
    chip.ro(0x75)


def s16(v):
    return max(-32768, min(32767, round(v))) & 0xFFFF


def update(chip, v):
    a = ACC[(chip.get(0x1C)[0] >> 3) & 3]
    g = GYR[(chip.get(0x1B)[0] >> 3) & 3]
    words = [s16(v['ax'] * a), s16(v['ay'] * a), s16(v['az'] * a), s16((v['temp'] - 36.53) * 340),
             s16(v['gx'] * g), s16(v['gy'] * g), s16(v['gz'] * g)]
    chip.put(0x3B, [b for w in words for b in (w >> 8, w & 0xFF)])
