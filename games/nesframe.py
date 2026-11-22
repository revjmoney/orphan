"""Frame buffer words from the Orphan NES block (5 pixels of 6 bits per word) -> PNG, with the FCEUX palette.
    py -3 nesframe.py frame.txt out.png [scale]
by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later."""
import sys

from PIL import Image

# FCEUX palette, RGB555 as 0bbbbbgggggrrrrr (from nes_ecp5's nes_palette_fceux.txt)
PAL555 = [0x39ce, 0x4464, 0x5400, 0x4c08, 0x3811, 0x0815, 0x0014, 0x002f, 0x00a8, 0x0100, 0x0140, 0x08e0,
          0x2ce3, 0x0000, 0x0000, 0x0000, 0x5ef7, 0x75c0, 0x74e4, 0x7810, 0x5c17, 0x2c1c, 0x00bb, 0x0539,
          0x01d1, 0x0240, 0x02a0, 0x1e40, 0x4600, 0x0000, 0x0000, 0x0000, 0x7fff, 0x7ee7, 0x7e4b, 0x7e28,
          0x7dfe, 0x59df, 0x31df, 0x1e7f, 0x1efe, 0x0b50, 0x2769, 0x4feb, 0x6fa0, 0x3def, 0x0000, 0x0000,
          0x7fff, 0x7f95, 0x7f58, 0x7f3a, 0x7f1f, 0x6f1f, 0x5aff, 0x577f, 0x539f, 0x53fc, 0x5fd5, 0x67f6,
          0x7bf3, 0x6318, 0x0000, 0x0000]


def rgb(i):
    v = PAL555[i & 63]
    return ((v & 31) * 255 // 31, (v >> 5 & 31) * 255 // 31, (v >> 10 & 31) * 255 // 31)


def to_image(words, scale=1):
    px = []
    for w in words:
        for k in range(5):
            px.append(w >> (6 * k) & 63)
    img = Image.new('RGB', (256, 240))
    img.putdata([rgb(p) for p in px[:256 * 240]])
    return img.resize((256 * scale, 240 * scale), Image.NEAREST) if scale > 1 else img


if __name__ == '__main__':
    words = [int(x, 16) for x in open(sys.argv[1]).read().split()]
    to_image(words, int(sys.argv[3]) if len(sys.argv) > 3 else 2).save(sys.argv[2])
    print(sys.argv[2])
