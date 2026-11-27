"""Orphan's own Commodore 64 test program (BASIC, loads at $0801):
    10 POKE53280,2:POKE53281,5:PRINT"ORPHAN C64"
    20 GOTO20
red border, green background, the text, then waits. A first board test.
    py -3 make_c64_testprg.py [out.prg]      (default c64roms/orphan_test.prg)
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import sys

POKE, PRINT, GOTO = 0x97, 0x99, 0x89
lines = [(10, bytes([POKE]) + b'53280,2:' + bytes([POKE]) + b'53281,5:' + bytes([PRINT]) + b'"ORPHAN C64"'),
         (20, bytes([GOTO]) + b'20')]
addr, out = 0x0801, bytearray()
for num, body in lines:
    nxt = addr + 4 + len(body) + 1
    out += bytes([nxt & 255, nxt >> 8, num & 255, num >> 8]) + body + b'\0'
    addr = nxt
out += b'\0\0'
HERE = os.path.dirname(os.path.abspath(__file__))
p = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, 'c64roms', 'orphan_test.prg')
open(p, 'wb').write(b'\x01\x08' + bytes(out))
print('wrote', p, len(out) + 2, 'bytes')
