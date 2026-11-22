"""Add Orphan's fan control (orphan_fan, slot 15) to an Ardzy example design and rebuild it.
    py -3 orphan/add-fan.py <ardzy project dir> [...]
Copies the project to fan-work/<name>, adds the fan ports + orphan_fan instance + fan pins, builds it with Ardzy's
flow (games-work/build.py) and keeps the new bitstream in orphan/fan-bits/<name>.bit (sync-boards installs it).
The Ardzy clone itself is not changed. by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import re
import shutil
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GAMES = os.path.join(REPO, 'games') if os.path.isdir(os.path.join(REPO, 'games')) else os.path.join(REPO, 'games-work')
FAN_V = os.path.join(GAMES, 'orphan_gb', 'orphan_fan.v')
WORK = os.path.join(REPO, 'fan-work')
BITS = os.path.join(REPO, 'orphan', 'fan-bits')
PINS = """
# orphan_fan (added by Orphan: fan control in every design, bus slot 15)
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {fan_pwm}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {fan_tach[0]}]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {fan_tach[1]}]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {fan_tach[2]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {fan_tach[3]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {fan_tach[4]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {fan_tach[5]}]
"""
INST = """    // Orphan: fan control in every design (orphan_fan, slot 15; the Orphan menu's Cooling page drives it)
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule"""


def patch(src):
    name = os.path.basename(os.path.normpath(src))
    dst = os.path.join(WORK, name)
    shutil.rmtree(dst, ignore_errors=True)
    shutil.copytree(src, dst, ignore=shutil.ignore_patterns('*.bit', '__pycache__'))
    top = os.path.join(dst, 'top.v')
    s = open(top, encoding='utf-8').read()
    if 'orphan_fan' in s:
        raise SystemExit('%s already has orphan_fan' % name)
    assert s.count('module top (') == 1 and s.count('bus_rdata(rd_info |') == 1, name
    s = s.replace('module top (', 'module top (\n    output wire       fan_pwm,       // Orphan: fan control\n'
                  '    input  wire [5:0] fan_tach,', 1)
    s = s.replace('bus_rdata(rd_info |', 'bus_rdata(rd_fan | rd_info |', 1)
    j = s.index('\n);', s.index('module top (')) + 3          # right after the port list
    s = s[:j] + '\n    wire [31:0] rd_fan;                // Orphan: orphan_fan read data' + s[j:]
    i = s.rindex('endmodule')
    s = s[:i] + INST + s[i + len('endmodule'):]
    s = '// Modified by Orphan (JMSCNC, 2026-11-22): orphan_fan added at slot 15.\n' + s
    open(top, 'w', encoding='utf-8').write(s)
    open(os.path.join(dst, 'pins.xdc'), 'a', encoding='utf-8').write(PINS)
    shutil.copy(FAN_V, dst)
    return name, dst


os.makedirs(BITS, exist_ok=True)
for src in sys.argv[1:]:
    name, dst = patch(src)
    print('== %s' % name, flush=True)
    r = subprocess.run([sys.executable, os.path.join(GAMES, 'build.py'), dst],
                       capture_output=True, text=True)
    lines = [l for l in (r.stdout + r.stderr).splitlines() if 'PASS' in l or 'FAIL' in l or 'used:' in l
             or 'ERROR' in l or 'BITSTREAM' in l]
    print('\n'.join('   ' + l.strip() for l in lines[-5:]), flush=True)
    bit = os.path.join(dst, name + '.bit')
    if r.returncode == 0 and os.path.exists(bit):
        shutil.copy(bit, os.path.join(BITS, name + '.bit'))
        print('   -> orphan/fan-bits/%s.bit' % name, flush=True)
    else:
        print('   FAILED', flush=True)
