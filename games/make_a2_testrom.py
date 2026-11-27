"""Orphan's own Apple IIe test ROM (16 KB, C000-FFFF; NOT Apple's ROM): used by sim/tb_a2.v and as a first board test.
Fills hi-res page 1 (every line: byte 0 = $01 one dot at the left edge, byte 39 = $40 one dot at the right edge,
byte 20 = $55 four dots), shows it (graphics, hi-res, full screen), turns the Disk II motor on and stores the first
two nibbles it reads at line 2 bytes 5 and 6, then loops: clicks the speaker, stores a pressed key at line 0 byte 10,
and $7F at line 0 byte 12 while button 0 is held.
    py -3 make_a2_testrom.py [out.bin]   (default a2roms/orphan_test_rom.bin; also writes sim/a2_rom.hex and
                                          sim/a2_vrom.hex = Orphan's own video ROM, see shared/a2rom.py)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'shared'))
import a2rom  # noqa: E402

ORG = 0xF000
code, labels, fix = bytearray(), {}, []


def b(*xs):
    code.extend(xs)


def label(n):
    labels[n] = ORG + len(code)


def branch(op, n):
    b(op, 0)
    fix.append(('rel', len(code) - 1, n))


def absl(op, n):                    # an instruction with a 16-bit operand that is a label
    b(op, 0, 0)
    fix.append(('abs', len(code) - 2, n))


def a16(op, addr):
    b(op, addr & 0xFF, addr >> 8)


b(0x78, 0xD8, 0xA2, 0xFF, 0x9A)                 # SEI, CLD, LDX #$FF, TXS
b(0xA9, 0x00, 0xA2, 0x00)                       # LDA #0; LDX #0: clear hi-res page 1, 32 pages unrolled
label('clr')
for page in range(0x20, 0x40):
    a16(0x9D, page << 8)                        # STA $pp00,X
b(0xE8)                                         # INX
branch(0xD0, 'clr')
for blk in range(64):                           # every 128-byte block holds 3 lines: bytes 0, 20, 39 of each
    for k in range(3):
        for col, v in ((0, 0x01), (20, 0x55), (39, 0x40)):
            b(0xA9, v)
            a16(0x8D, 0x2000 + blk * 0x80 + k * 40 + col)
for sw in (0xC050, 0xC057, 0xC052, 0xC054):     # graphics, hi-res, full screen, page 1
    a16(0x8D, sw)
a16(0xAD, 0xC0E9)                               # Disk II: motor on (slot 6)
a16(0xAD, 0xC0EA)                               # drive 1
a16(0xAD, 0xC0EE)                               # read mode
label('dk1')
a16(0xAD, 0xC0EC)                               # LDA data latch
branch(0x10, 'dk1')                             # until bit 7
a16(0x8D, 0x2805)
label('dk2')
a16(0xAD, 0xC0EC)
branch(0x10, 'dk2')
a16(0x8D, 0x2806)
label('main')
a16(0xAD, 0xC030)                               # click the speaker
b(0xA2, 0x40)                                   # LDX #$40
label('dly')
b(0xCA)
branch(0xD0, 'dly')
a16(0xAD, 0xC000)                               # key?
branch(0x10, 'nokey')
a16(0x8D, 0xC010)                               # clear the strobe
a16(0x8D, 0x200A)
label('nokey')
a16(0xAD, 0xC061)                               # button 0
branch(0x10, 'nob')
b(0xA9, 0x7F)
a16(0x8D, 0x200C)
absl(0x4C, 'main')
label('nob')
b(0xA9, 0x00)
a16(0x8D, 0x200C)
absl(0x4C, 'main')
while len(code) < 0x1000:
    code.append(0)

for kind, at, n in fix:
    t = labels[n]
    if kind == 'rel':
        d = t - (ORG + at + 1)
        assert -128 <= d < 128, n
        code[at] = d & 0xFF
    else:
        code[at], code[at + 1] = t & 0xFF, t >> 8

rom = bytearray(16384)
rom[0x3000:0x3000 + len(code)] = code
for v in (0x3FFA, 0x3FFC, 0x3FFE):              # NMI, RESET, IRQ -> $F000
    rom[v], rom[v + 1] = 0x00, 0xF0

HERE = os.path.dirname(os.path.abspath(__file__))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'a2roms', 'orphan_test_rom.bin')
os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, 'wb').write(rom)
for name, data in (('a2_rom.hex', bytes(rom)), ('a2_vrom.hex', a2rom.video_rom())):
    with open(os.path.join(HERE, 'sim', name), 'w') as f:
        for w in struct.unpack('<%dI' % (len(data) // 4), data):
            f.write('%08x\n' % w)
print('wrote', out, len(code), 'bytes of code')
