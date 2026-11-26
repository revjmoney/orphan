r"""Clean GHDL's Verilog for Icarus and Yosys.  py -3 fix_ghdl.py A2601top_ghdl.v
 - broken escaped names (aud0_\output ) -> plain names
 - a signal fed by an instance output comes out declared twice plus "assign x = x; // (signal)": drop the second
   identical declaration and the self-assignment
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import re
import sys

p = sys.argv[1]
s = open(p, encoding='latin-1').read()
s = re.sub(r'(\w*)\\output ', lambda m: m.group(1) + 'aout ', s)
assert chr(92) not in s, 'escaped names left'
out, seen, dropped, selfa = [], set(), 0, 0
for ln in s.split('\n'):
    if ln.startswith('module '):
        seen = set()
    m = re.match(r'\s*(wire|reg)\s*(\[[^\]]*\])?\s*(\w+)\s*;', ln)
    if m:
        key = (m.group(2) or '', m.group(3))
        if key in seen:
            dropped += 1
            continue
        seen.add(key)
    m = re.match(r'\s*assign (\w+) = (\w+); // \(signal\)', ln)
    if m and m.group(1) == m.group(2):
        selfa += 1
        continue
    out.append(ln)
open(p, 'w', encoding='latin-1').write('\n'.join(out))
print('ok: %d duplicate declarations, %d self-assignments removed' % (dropped, selfa))
