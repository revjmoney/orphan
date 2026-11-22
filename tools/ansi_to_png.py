"""Render a terminal recording (the raw bytes `script` saves) to a PNG, the way a good terminal shows it.
A small VT100/xterm emulator: cursor moves, erase, 16/256/true colours, bold. Block elements (half and quarter
blocks, the Orphan monkey is made of them) are drawn as exact rectangles, so no font can break them.
    py -3 ansi_to_png.py menu.raw menu.png [cols rows] [font.ttf]
by JMSCNC, makers of RotatoCAM. GPL-3 + attribution."""
import re
import sys

from PIL import Image, ImageDraw, ImageFont

raw = open(sys.argv[1], 'rb').read().decode('utf-8', 'replace')
out = sys.argv[2]
COLS = int(sys.argv[3]) if len(sys.argv) > 3 else 118
ROWS = int(sys.argv[4]) if len(sys.argv) > 4 else 38
FONT = sys.argv[5] if len(sys.argv) > 5 else r'C:\Windows\Fonts\CascadiaMono.ttf'

BASE = [(12, 12, 12), (197, 15, 31), (19, 161, 14), (193, 156, 0), (0, 55, 218), (136, 23, 152), (58, 150, 221),
        (204, 204, 204), (118, 118, 118), (231, 72, 86), (22, 198, 12), (249, 241, 165), (59, 120, 255),
        (180, 0, 158), (97, 214, 214), (242, 242, 242)]


def xterm(n):
    if n < 16:
        return BASE[n]
    if n < 232:
        n -= 16
        lv = [0, 95, 135, 175, 215, 255]
        return (lv[n // 36], lv[n // 6 % 6], lv[n % 6])
    v = 8 + (n - 232) * 10
    return (v, v, v)


DEF_FG, DEF_BG = (204, 204, 204), (12, 12, 12)
grid = [[(' ', DEF_FG, DEF_BG, False) for _ in range(COLS)] for _ in range(ROWS)]
cy = cx = 0
fg, bg, bold, rev = DEF_FG, DEF_BG, False, False
saved = (0, 0)


def put(ch):
    global cx, cy
    if cx >= COLS:
        cx = 0
        cy = min(ROWS - 1, cy + 1)
    f, b = (bg, fg) if rev else (fg, bg)
    grid[cy][cx] = (ch, f, b, bold)
    cx += 1


def sgr(params):
    global fg, bg, bold, rev
    p = [int(x) if x else 0 for x in params.split(';')] if params else [0]
    i = 0
    while i < len(p):
        v = p[i]
        if v == 0:
            fg, bg, bold, rev = DEF_FG, DEF_BG, False, False
        elif v == 1:
            bold = True
        elif v == 22:
            bold = False
        elif v == 7:
            rev = True
        elif v == 27:
            rev = False
        elif 30 <= v <= 37:
            fg = BASE[v - 30 + (8 if bold else 0)]
        elif v == 39:
            fg = DEF_FG
        elif 40 <= v <= 47:
            bg = BASE[v - 40]
        elif v == 49:
            bg = DEF_BG
        elif 90 <= v <= 97:
            fg = BASE[v - 90 + 8]
        elif 100 <= v <= 107:
            bg = BASE[v - 100 + 8]
        elif v in (38, 48) and i + 1 < len(p):
            if p[i + 1] == 5 and i + 2 < len(p):
                c = xterm(p[i + 2]); i += 2
            elif p[i + 1] == 2 and i + 4 < len(p):
                c = tuple(p[i + 2:i + 5]); i += 4
            else:
                c = None
            if c:
                if v == 38:
                    fg = c
                else:
                    bg = c
        i += 1


tok = re.compile(r'\x1b\[([?>]?)([0-9;]*)([A-Za-z@`])|\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)|\x1b[()][0-9A-Za-z]|\x1b[78=>cM]|[\x00-\x1f]|[^\x00-\x1f\x1b]+')
for m in tok.finditer(raw):
    s = m.group(0)
    if m.group(3):
        priv, params, cmd = m.group(1), m.group(2), m.group(3)
        if priv:
            continue
        n = [int(x) if x else 0 for x in params.split(';')] if params else []
        a = n[0] if n and n[0] else 1
        if cmd in 'Hf':
            cy = min(ROWS - 1, max(0, (n[0] if n and n[0] else 1) - 1))
            cx = min(COLS - 1, max(0, (n[1] if len(n) > 1 and n[1] else 1) - 1))
        elif cmd == 'A':
            cy = max(0, cy - a)
        elif cmd in 'Be':
            cy = min(ROWS - 1, cy + a)
        elif cmd in 'Ca':
            cx = min(COLS - 1, cx + a)
        elif cmd == 'D':
            cx = max(0, cx - a)
        elif cmd in 'G`':
            cx = min(COLS - 1, a - 1)
        elif cmd == 'd':
            cy = min(ROWS - 1, a - 1)
        elif cmd == 'K':
            mode = n[0] if n else 0
            rng = range(cx, COLS) if mode == 0 else range(0, cx + 1) if mode == 1 else range(COLS)
            for x in rng:
                grid[cy][x] = (' ', fg, bg, False)
        elif cmd == 'J':
            mode = n[0] if n else 0
            rows = range(cy + 1, ROWS) if mode == 0 else range(0, cy) if mode == 1 else range(ROWS)
            if mode == 0:
                for x in range(cx, COLS):
                    grid[cy][x] = (' ', fg, bg, False)
            for y in rows:
                grid[y] = [(' ', fg, bg, False) for _ in range(COLS)]
        elif cmd == 'X':
            for x in range(cx, min(COLS, cx + a)):
                grid[cy][x] = (' ', fg, bg, False)
        elif cmd == 'P':
            row = grid[cy]
            del row[cx:cx + a]
            row.extend([(' ', fg, bg, False)] * (COLS - len(row)))
        elif cmd == '@':
            row = grid[cy]
            for _ in range(a):
                row.insert(cx, (' ', fg, bg, False))
            del row[COLS:]
        elif cmd == 'm':
            sgr(params)
        continue
    if s.startswith('\x1b'):
        if s == '\x1b7':
            saved = (cy, cx)
        elif s == '\x1b8':
            cy, cx = saved
        continue
    if s == '\r':
        cx = 0
    elif s == '\n':
        cy = min(ROWS - 1, cy + 1)
    elif s == '\b':
        cx = max(0, cx - 1)
    elif s == '\t':
        cx = min(COLS - 1, (cx // 8 + 1) * 8)
    elif s[0] >= ' ':
        for ch in s:
            put(ch)

CW, CH = 12, 25
font = ImageFont.truetype(FONT, 20)
fontb = ImageFont.truetype(FONT.replace('Mono.ttf', 'Mono.ttf'), 20)
img = Image.new('RGB', (COLS * CW + 24, ROWS * CH + 24), DEF_BG)
d = ImageDraw.Draw(img)
QUAD = {'\u2596': 4, '\u2597': 8, '\u2598': 1, '\u2599': 13, '\u259a': 9, '\u259b': 7, '\u259c': 11, '\u259d': 2,
        '\u259e': 6, '\u259f': 14}                                    # bits: UL 1, UR 2, LL 4, LR 8
for y, row in enumerate(grid):
    for x, (ch, f, b, bo) in enumerate(row):
        X, Y = 12 + x * CW, 12 + y * CH
        d.rectangle([X, Y, X + CW - 1, Y + CH - 1], fill=b)
        h2, w2 = CH // 2, CW // 2
        if ch == '\u2588':
            d.rectangle([X, Y, X + CW - 1, Y + CH - 1], fill=f)
        elif ch == '\u2580':
            d.rectangle([X, Y, X + CW - 1, Y + h2 - 1], fill=f)
        elif ch == '\u2584':
            d.rectangle([X, Y + h2, X + CW - 1, Y + CH - 1], fill=f)
        elif ch == '\u258c':
            d.rectangle([X, Y, X + w2 - 1, Y + CH - 1], fill=f)
        elif ch == '\u2590':
            d.rectangle([X + w2, Y, X + CW - 1, Y + CH - 1], fill=f)
        elif ch in QUAD:
            q = QUAD[ch]
            for bit, (qx, qy) in ((1, (0, 0)), (2, (1, 0)), (4, (0, 1)), (8, (1, 1))):
                if q & bit:
                    d.rectangle([X + qx * w2, Y + qy * h2, X + (qx + 1) * w2 - 1 if qx == 0 else X + CW - 1,
                                 Y + (qy + 1) * h2 - 1 if qy == 0 else Y + CH - 1], fill=f)
        elif ch != ' ':
            d.text((X, Y + 2), ch, font=fontb if bo else font, fill=f)
img.save(out, optimize=True)
print(out, img.size)
