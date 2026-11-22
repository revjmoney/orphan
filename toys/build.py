"""Build the main Orphan graphics-toys project with the established Ardzy flow."""
import os,sys,tempfile,json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
temp=Path(os.environ.get('TEMP') or __import__('tempfile').gettempdir())/'orphan-toys'
temp.mkdir(parents=True,exist_ok=True);tempfile.tempdir=str(temp)
ardzy=Path(os.environ.get('ARDZY_PC_APP',str(ROOT.parent/'ardzy'/'pc_app')))
sys.path[:0]=[str(ardzy),str(ardzy/'fpga')]
from fpga import flow
def log(msg,kind=''):print(str(msg),flush=True)
flow.build(str(ROOT/'orphan_toys'),log=log)
report=flow.build_report(str(ROOT/'orphan_toys'))
(ROOT/'build-report.json').write_text(json.dumps(report,indent=2))
if not report['timing_ok']:raise SystemExit('Timing failed; do not deploy')
