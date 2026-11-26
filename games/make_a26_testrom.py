"""Orphan's own Atari 2600 test cart (4 KB): 262-line NTSC frames, 192 visible lines whose background colour is
(frame start colour + line), the start colour moves by one each frame while joystick 1's fire is held, and a steady
tone on channel 0 (AUDC0 4, AUDF0 16, AUDV0 8). Used by sim/tb_a26.v and as a first board test.
    py -3 make_a26_testrom.py [out.bin]       (default a26roms/orphan_test.bin)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import sys

VSYNC, VBLANK, WSYNC, COLUBK, AUDC0, AUDF0, AUDV0, INPT4 = 0x00, 0x01, 0x02, 0x09, 0x15, 0x17, 0x19, 0x0C
code, labels, fix = bytearray(), {}, []
ORG = 0xF000


def b(*xs):
    code.extend(xs)


def label(n):
    labels[n] = ORG + len(code)


def branch(op, n):                  # relative branch to a label (back or forward)
    b(op, 0)
    fix.append(('rel', len(code) - 1, n))


def jmp(n):
    b(0x4C, 0, 0)
    fix.append(('abs', len(code) - 2, n))


b(0x78, 0xD8, 0xA2, 0xFF, 0x9A)                 # SEI, CLD, LDX #$FF, TXS
b(0xA9, 0x00, 0xA2, 0x00)                       # LDA #0, LDX #0
label('clr')
b(0x95, 0x00, 0xE8, 0xE0, 0x80)                 # STA 0,X; INX; CPX #$80 (TIA registers to 0)
branch(0xD0, 'clr')
b(0xA9, 4, 0x85, AUDC0, 0xA9, 16, 0x85, AUDF0, 0xA9, 8, 0x85, AUDV0)
b(0xA9, 0x00, 0x85, 0x80)                       # start colour (RAM $80) = 0
label('frame')
b(0xA9, 0x02, 0x85, VBLANK, 0x85, VSYNC)        # VBLANK and VSYNC on
b(0x85, WSYNC, 0x85, WSYNC, 0x85, WSYNC)        # 3 lines of VSYNC
b(0xA9, 0x00, 0x85, VSYNC)
b(0xA2, 37)                                     # 37 lines of VBLANK
label('vbl')
b(0x85, WSYNC, 0xCA)
branch(0xD0, 'vbl')
b(0xA9, 0x00, 0x85, VBLANK)
b(0xA5, INPT4)                                  # fire pressed = bit 7 low
branch(0x30, 'nofire')
b(0xE6, 0x80)                                   # INC $80
label('nofire')
b(0xA6, 0x80, 0xA0, 192)                        # LDX $80, LDY #192
label('kern')
b(0x85, WSYNC, 0x86, COLUBK, 0xE8, 0xE8, 0x88)  # one line: colour X, X += 2 (the low bit is not used)
branch(0xD0, 'kern')
b(0xA9, 0x02, 0x85, VBLANK)
b(0xA2, 30)                                     # 30 lines of overscan
label('ovs')
b(0x85, WSYNC, 0xCA)
branch(0xD0, 'ovs')
jmp('frame')

for kind, at, n in fix:
    t = labels[n]
    if kind == 'rel':
        d = t - (ORG + at + 1)
        assert -128 <= d < 128
        code[at] = d & 0xFF
    else:
        code[at], code[at + 1] = t & 0xFF, t >> 8
rom = bytearray(code) + bytearray(4096 - len(code))
rom[0xFFC - 0x000:0xFFE] = bytes([0x00, 0xF0])   # reset vector -> $F000
rom[0xFFE:0x1000] = bytes([0x00, 0xF0])
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), 'a26roms', 'orphan_test.bin')
os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, 'wb').write(rom)
print('%s: %d bytes of code, 4096 byte cart' % (out, len(code)))
