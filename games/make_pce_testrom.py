"""Orphan's own PC Engine test HuCard (8 KB): turns the VDC's picture on (256 x 240, background only), makes the whole
picture VCE colour 0 = $0AB (GRB 2-5-3), or $1C7 while pad button I is held, and plays a square wave on PSG
channel 0. Used by sim/tb_pce.v and as a first board test.
    py -3 make_pce_testrom.py [out.pce]       (default pceroms/orphan_test.pce; also writes sim/pce_rom.hex)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import struct
import sys

ORG = 0xE000
code, labels, fix = bytearray(), {}, []


def b(*xs):
    code.extend(xs)


def label(n):
    labels[n] = ORG + len(code)


def branch(op, n):
    b(op, 0)
    fix.append(('rel', len(code) - 1, n))


def jmp(n):
    b(0x4C, 0, 0)
    fix.append(('abs', len(code) - 2, n))


def sta(addr):
    b(0x8D, addr & 0xFF, addr >> 8)


def lda(v):
    b(0xA9, v)


def vdc(reg, val):                  # ST0 #reg; ST1 #lo; ST2 #hi
    b(0x03, reg, 0x13, val & 0xFF, 0x23, val >> 8)


def colour(i, grb):                 # VCE colour table entry i = grb (9 bits)
    lda(i & 0xFF); sta(0x0402); lda(i >> 8); sta(0x0403)
    lda(grb & 0xFF); sta(0x0404); lda(grb >> 8); sta(0x0405)


b(0x78, 0xD4, 0xD8)                 # SEI, CSH (7.16 MHz), CLD
lda(0xFF); b(0x53, 0x01)            # TAM #$01: MPR0 = $FF (the hardware page)
lda(0xF8); b(0x53, 0x02)            # TAM #$02: MPR1 = $F8 (RAM)
b(0xA2, 0xFF, 0x9A)                 # LDX #$FF, TXS
lda(0x00); sta(0x0400)              # VCE: 5.37 MHz dots
for r in (0x00, 0x01, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0F, 0x10, 0x11, 0x12, 0x13):
    vdc(r, 0x0000)                  # every VDC register to a known value first
vdc(0x0A, 0x0202)                   # HSR
vdc(0x0B, 0x031F)                   # HDR: 32 tiles = 256 dots
vdc(0x0C, 0x0F02)                   # VSR
vdc(0x0D, 0x00EF)                   # VDR: 240 lines
vdc(0x0E, 0x0003)                   # VCR
vdc(0x09, 0x0000)                   # MWR: 32 x 32 tiles
vdc(0x05, 0x0080)                   # CR: background on
colour(0x000, 0x0AB)
colour(0x100, 0x0AB)                # (the overscan colour too)
# PSG channel 0: a square wave
lda(0x00); sta(0x0800)              # channel 0
lda(0xFF); sta(0x0801)              # main volume
lda(0x00); sta(0x0804)              # off, waveform write
for k in range(32):
    lda(31 if k < 16 else 0); sta(0x0806)
lda(0x40); sta(0x0802); lda(0x00); sta(0x0803)   # frequency $040
lda(0xFF); sta(0x0805)              # balance
lda(0x9F); sta(0x0804)              # on, volume 31
label('main')
lda(0x01); sta(0x1000)              # pad: SEL = 1 (directions)
lda(0x00); sta(0x1000)              # SEL = 0: buttons I, II, Select, Run in bits 0..3 (0 = pressed)
b(0xAD, 0x00, 0x10)                 # LDA $1000
b(0x29, 0x01)                       # AND #1
branch(0xF0, 'held')
colour(0x000, 0x0AB)
jmp('main')
label('held')
colour(0x000, 0x1C7)
jmp('main')

for kind, at, n in fix:
    t = labels[n]
    if kind == 'rel':
        d = t - (ORG + at + 1)
        assert -128 <= d < 128, n
        code[at] = d & 0xFF
    else:
        code[at], code[at + 1] = t & 0xFF, t >> 8

rom = bytearray(8192)
rom[:len(code)] = code
for v in (0x1FF6, 0x1FF8, 0x1FFA, 0x1FFC, 0x1FFE):     # IRQ2, IRQ1, timer, NMI, RESET -> $E000
    rom[v], rom[v + 1] = 0x00, 0xE0

HERE = os.path.dirname(os.path.abspath(__file__))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'pceroms', 'orphan_test.pce')
os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, 'wb').write(rom)
with open(os.path.join(HERE, 'sim', 'pce_rom.hex'), 'w') as f:
    for w in struct.unpack('<1024Q', bytes(rom)):
        f.write('%016x\n' % w)
print('wrote', out, len(code), 'bytes of code')
