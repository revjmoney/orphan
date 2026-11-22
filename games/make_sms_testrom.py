"""A tiny self-made Master System / Game Gear test program (hand-assembled Z80), for the Orphan SMS core.
    py -3 make_sms_testrom.py <out_dir>    -> orphan_test.sms and orphan_test.gg
What it does: 16 color-bar tiles across the screen (every palette color), scrolls them sideways one pixel per frame,
plays a tone on the SN76489 whose pitch follows the pad (directions + buttons). Checks the Z80, the VDP (registers,
CRAM, VRAM, name table, scroll, frame flag), the PSG and the pad port in one go.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import sys

CODE = 0x0100
VDPREGS = [0x04, 0x80, 0x80, 0x81, 0xFF, 0x82, 0xFF, 0x83, 0xFF, 0x84, 0xFF, 0x85, 0xFB, 0x86,
           0x00, 0x87, 0x00, 0x88, 0x00, 0x89, 0xFF, 0x8A]
SMS_PAL = [0x00, 0x03, 0x0C, 0x30, 0x0F, 0x3C, 0x33, 0x3F, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x15, 0x2A]


def build(gg):
    rom = bytearray(32768)
    rom[0x0000:0x0009] = bytes([0xF3, 0xED, 0x56, 0x31, 0xF0, 0xDF, 0xC3, CODE & 255, CODE >> 8])  # di, im 1, sp, jp
    rom[0x0038:0x003B] = bytes([0xFB, 0xED, 0x4D])                    # ei, reti
    rom[0x0066:0x0068] = bytes([0xED, 0x45])                          # retn (Pause)
    data = 0x0400
    regs_at, pal_at, tiles_at, names_at = data, data + 0x40, data + 0x80, data + 0x300
    c = []

    def ld_hl(a):
        c.extend([0x21, a & 255, a >> 8])

    def vdp_addr(lo, hi):
        c.extend([0x3E, lo, 0xD3, 0xBF, 0x3E, hi, 0xD3, 0xBF])

    ld_hl(regs_at); c += [0x06, len(VDPREGS), 0x0E, 0xBF, 0xED, 0xB3]        # VDP registers
    vdp_addr(0x00, 0xC0); ld_hl(pal_at); c += [0x06, 32, 0x0E, 0xBE, 0xED, 0xB3]  # palette (CRAM)
    vdp_addr(0x00, 0x40); ld_hl(tiles_at); c += [0x06, 0x00, 0xED, 0xB3, 0xED, 0xB3]  # 16 tiles (512 bytes)
    vdp_addr(0x00, 0x78); ld_hl(names_at); c += [0x16, 0x07, 0x06, 0x00, 0xED, 0xB3, 0x15, 0x20, 0xF9]  # name table
    c += [0x3E, 0xC0, 0xD3, 0xBF, 0x3E, 0x81, 0xD3, 0xBF]              # display on
    for b in (0x8E, 0x0F, 0x92, 0xBF, 0xDF, 0xFF):                    # PSG: tone 0 at 440 Hz, the rest silent
        c += [0x3E, b, 0xD3, 0x7F]
    c += [0x1E, 0x00]                                                 # e = frame counter
    loop = CODE + len(c)
    c += [0xDB, 0xBF, 0x07, 0x30, 0xFB]                               # wait for the frame flag
    c += [0x1C, 0x7B, 0xD3, 0xBF, 0x3E, 0x88, 0xD3, 0xBF]             # scroll x = frame counter
    c += [0xDB, 0xDC, 0x2F, 0xE6, 0x3F, 0x47,                         # pad (pressed = 1)
          0xE6, 0x0F, 0xF6, 0x80, 0xD3, 0x7F,                         # tone low bits
          0x78, 0x0F, 0x0F, 0x0F, 0x0F, 0xE6, 0x03, 0xC6, 0x08, 0xD3, 0x7F,  # tone high bits
          0xC3, loop & 255, loop >> 8]
    rom[CODE:CODE + len(c)] = bytes(c)
    rom[regs_at:regs_at + len(VDPREGS)] = bytes(VDPREGS)
    if gg:                                                            # Game Gear CRAM: 2 bytes a color, BGR 4-4-4
        pal = []
        for v in SMS_PAL:
            r, g, b = (v & 3) * 5, (v >> 2 & 3) * 5, (v >> 4 & 3) * 5
            pal += [g << 4 | r, b]
    else:
        pal = SMS_PAL + SMS_PAL
    rom[pal_at:pal_at + 32] = bytes(pal)
    tiles = []
    for n in range(16):
        for _ in range(8):
            tiles += [0xFF if n >> p & 1 else 0x00 for p in range(4)]
    rom[tiles_at:tiles_at + 512] = bytes(tiles)
    names = []
    for row in range(28):
        for col in range(32):
            names += [((col + row) // 2) & 15, 0]
    rom[names_at:names_at + len(names)] = bytes(names)
    rom[0x7FF0:0x7FF8] = b'TMR SEGA'
    return bytes(rom)


if __name__ == '__main__':
    out = sys.argv[1] if len(sys.argv) > 1 else '.'
    for gg, name in ((False, 'orphan_test.sms'), (True, 'orphan_test.gg')):
        open(os.path.join(out, name), 'wb').write(build(gg))
        print('wrote', os.path.join(out, name))
