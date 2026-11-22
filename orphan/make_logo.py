"""Turn the Orphan monkey logo (gold on black) into terminal block art for Orphan.

Each character cell holds two pixels (top + bottom) using the half-block glyphs, so the art has square pixels.
Output is plain text (the menu colors it gold); --ansi also writes a ready-to-cat file with 256-color codes.
  py -3 make_logo.py monkey.png 44 logo_big.txt
"""
import sys
from PIL import Image

src, width, out = sys.argv[1], int(sys.argv[2]), sys.argv[3]
ansi = '--ansi' in sys.argv

im = Image.open(src).convert('RGBA')
bg = Image.new('RGBA', im.size, (0, 0, 0, 255))
im = Image.alpha_composite(bg, im).convert('RGB')
h_px = round(width * im.height / im.width)
h_px += h_px % 2                                   # even number of pixel rows
small = im.resize((width, h_px), Image.LANCZOS)


def gold(p):
    r, g, b = p
    return r > 110 and g > 70 and r > b + 40       # the logo's gold/orange, not the black fill


rows = []
for y in range(0, h_px, 2):
    line = ''
    for x in range(width):
        t, b = gold(small.getpixel((x, y))), gold(small.getpixel((x, y + 1)))
        line += '\u2588' if t and b else '\u2580' if t else '\u2584' if b else ' '
    rows.append(line.rstrip())

# trim blank rows top and bottom
while rows and not rows[0].strip():
    rows.pop(0)
while rows and not rows[-1].strip():
    rows.pop()

with open(out, 'w', encoding='utf-8') as f:
    for r in rows:
        f.write(('\x1b[38;5;214m' + r + '\x1b[0m' if ansi else r) + '\n')
print('%s: %d cols x %d rows' % (out, width, len(rows)))
