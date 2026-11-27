"""Orphan: after GHDL (and fix_ghdl.py), one change to the C64 netlist for the built-in toolchain:
the VIC-II's 39-entry character store is a plain shift register; Yosys turns it into chained SRL32 cells whose
cascade output nextpnr can not route. Clearing it on the VIC's reset makes it ordinary flip-flops (no SRL has a
reset); the C64 never shifts it during reset, so nothing changes for the machine.
    py -3 fix_c64.py ../orphan_c64/fpga64_sid_iec_ghdl.v
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import re
import sys

p = sys.argv[1]
s = open(p, encoding='latin-1').read()
m = re.search(r'assign charstore = (n\d+_q);', s)
q = m.group(1)
old = '    %s <= ' % q
i = s.index(old)
j = s.index(';', i)
expr = s[i + len(old):j]
s = s[:i] + '    %s <= reset ? 468\'d0 : %s' % (q, expr) + s[j:]
open(p, 'w', encoding='latin-1').write(s)
print('charstore (%s) now clears on reset' % q)
