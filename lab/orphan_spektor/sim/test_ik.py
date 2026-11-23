#!/usr/bin/env python3
"""INTERSEKTOR simulation test: tb_ik.v drives the bridge with behavioural UART devices that have their own timing
(2 % fast and slow senders, 9600 baud through WIRE, a break) and decodes the output pins with its own receivers.
   py -3 test_ik.py          (needs Icarus Verilog on the PATH, or IVERILOG_BIN = its bin folder; about 6 minutes)
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
BIN = os.environ.get('IVERILOG_BIN', '')


def tool(name):
    return os.path.join(BIN, name) if BIN else name


vvp = os.path.join(HERE, 'ik.vvp')
subprocess.run([tool('iverilog'), '-g2012', '-o', vvp, os.path.join(HERE, 'tb_ik.v'),
                os.path.join(HERE, '..', 'intersektor.v')], check=True)
out = subprocess.run([tool('vvp'), '-n', vvp], capture_output=True, text=True, cwd=HERE).stdout
print(out, end='')
open(os.path.join(HERE, 'result.txt'), 'w').write(out)
fails = [l for l in out.splitlines() if l.startswith('FAIL') or l == 'TIMEOUT']
passes = sum(1 for l in out.splitlines() if l.startswith('PASS'))
print('\n%d passed, %d failed' % (passes, len(fails)))
sys.exit(1 if fails or 'DONE 0' not in out else 0)
