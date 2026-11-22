"""Build an Ardzy FPGA project from the command line with Ardzy's own flow (Yosys + nextpnr + fasm2bit).
   py -3 build.py <project_dir>"""
import os, sys, time
# Ardzy's PC app (its FPGA flow): ARDZY_PC_APP, else the ardzy/ clone at the repo root (tools/fetch_sources.sh)
ARDZY = os.environ.get('ARDZY_PC_APP') or os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'ardzy', 'pc_app')
sys.path.insert(0, ARDZY)
sys.path.insert(0, os.path.join(ARDZY, 'fpga'))
from fpga import flow   # noqa: E402

def log(msg, kind=''):
    print(('== ' if kind == 'head' else '   ') + str(msg), flush=True)

t = time.time()
bit = flow.build(os.path.abspath(sys.argv[1]), log=log)
print('BITSTREAM', bit, os.path.getsize(bit), 'bytes in %.0f s' % (time.time() - t))
