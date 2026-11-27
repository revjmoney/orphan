"""Orphan's own Atari 7800 test cart (16 KB, .a78 with a header): locks the console in 7800 mode, turns MARIA's
display DMA off so the whole picture is the background colour $46, $C8 while a fire button is held, and plays a
tone on TIA channel 0 (AUDC0 4, AUDF0 16, AUDV0 8). A first board test without any game.
    py -3 make_a78_testrom.py [out.a78]       (default a78roms/orphan_test.a78)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import sys

ORG = 0xC000
code, labels, fix = bytearray(), {}, []


def b(*xs):
    code.extend(xs)


def label(n):
    labels[n] = ORG + len(code)


def branch(op, n):
    b(op, 0)
    fix.append((len(code) - 1, n))


INPTCTRL, INPT4, AUDC0, AUDF0, AUDV0, BACKGRND, CTRL = 0x01, 0x0C, 0x15, 0x17, 0x19, 0x20, 0x3C
b(0x78, 0xD8)                                   # SEI, CLD
b(0xA9, 0x07, 0x85, INPTCTRL)                   # lock: 7800 mode, MARIA on, BIOS off
b(0xA2, 0xFF, 0x9A)                             # LDX #$FF, TXS
b(0xA9, 0x60, 0x85, CTRL)                       # MARIA: display DMA off (the background colour everywhere)
b(0xA9, 0x04, 0x85, AUDC0, 0xA9, 0x10, 0x85, AUDF0, 0xA9, 0x08, 0x85, AUDV0)
label('loop')
b(0xA5, INPT4)                                  # fire (one-button sense): bit 7 = 0 while held
branch(0x10, 'held')
b(0xA9, 0x46, 0x85, BACKGRND)
branch(0x50, 'loop')                            # BVC (V is never set here): back
label('held')
b(0xA9, 0xC8, 0x85, BACKGRND)
branch(0x50, 'loop')
for at, n in fix:
    d = labels[n] - (ORG + at + 1)
    assert -128 <= d < 128
    code[at] = d & 0xFF

rom = bytearray(b'\xFF' * 16384)
rom[:len(code)] = code
for v in (0x3FFA, 0x3FFC, 0x3FFE):              # NMI, RESET, IRQ -> $C000
    rom[v], rom[v + 1] = 0x00, 0xC0
hdr = bytearray(128)
hdr[0] = 3
hdr[1:10] = b'ATARI7800'
hdr[17:17 + 17] = b'Orphan test cart'.ljust(17, b'\0')[:17]
hdr[49:53] = len(rom).to_bytes(4, 'big')
hdr[55] = 1                                     # joystick on port 1
hdr[100:100 + 28] = b'ACTUAL CART DATA STARTS HERE'
HERE = os.path.dirname(os.path.abspath(__file__))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'a78roms', 'orphan_test.a78')
os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, 'wb').write(bytes(hdr) + bytes(rom))
print('wrote', out, len(code), 'bytes of code')
