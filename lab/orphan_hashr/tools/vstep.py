# L3+ undervolt search on one header: steps the PIC's stored voltage byte by STEP (the direction that lowers the
# voltage on an S9), runs a chip test at each step and stops at the first sign of trouble:
#   chips dead / weak / bad, hashrate under 108 MH/s, or the chip temperature rising 3 C over the baseline (= wrong way).
# usage: python3 vstep.py J6 [step] [seconds]     prints one line per step; leaves the last good byte set.
import json, subprocess, sys, time, urllib.request

J = sys.argv[1]
jn = int(J[1:])
STEP = int(sys.argv[2]) if len(sys.argv) > 2 else 10
SECS = int(sys.argv[3]) if len(sys.argv) > 3 else 90
APP = '/opt/ardzy/projects/orphan_hashr/app'


def app(*a):
    return subprocess.run([APP] + list(a), capture_output=True, text=True).stdout.strip()


def state():
    return json.load(urllib.request.urlopen('http://127.0.0.1:8000/api/state'))


def l3(d):
    return next(x for x in d['l3'] if x['header'] == J)


def byte(b=None):
    a = ['python3', '/root/picvolt.py', str(jn)] + ([str(b)] if b is not None else [])
    out = subprocess.run(a, capture_output=True, text=True).stdout.strip()
    return int(out.split('now ')[1])


def test():
    print(' ', app('l3test', str(SECS), J), flush=True)
    time.sleep(SECS + 4)
    while l3(state()).get('test', {}).get('state') == 'running':
        time.sleep(2)
    d = state()
    x = l3(d)
    t = x['test']
    v = t['verdict']
    trouble = {k: [i for i, s in enumerate(v) if s == k] for k in ('dead', 'weak', 'bad')}
    return t['mhs'], t['total'], t['invalid'], trouble, x['chip_c'], x['pcb_c']


start = byte()
print('%s start byte %d' % (J, start), flush=True)
mhs, n, bad, tr, chip, pcb = test()
base_chip = chip
print('%s byte %3d: %.0f MH/s, %d nonces, %d bad, trouble %s, chip %s C, board %s C  (baseline)' % (J, start, mhs, n, bad, tr, chip, pcb), flush=True)
good = start
b = start
while b + STEP <= 255:
    b += STEP
    byte(b)
    time.sleep(20)
    mhs, n, bad, tr, chip, pcb = test()
    print('%s byte %3d: %.0f MH/s, %d nonces, %d bad, trouble %s, chip %s C, board %s C' % (J, b, mhs, n, bad, tr, chip, pcb), flush=True)
    if chip is not None and base_chip is not None and chip >= base_chip + 3:
        print('  chip temperature ROSE: this direction raises the voltage. Back to %d.' % start, flush=True)
        byte(start)
        good = start
        break
    if any(tr.values()) or mhs < 108 or bad > 3:
        print('  trouble at %d: the floor. Back off 2 steps.' % b, flush=True)
        good = max(start, b - 2 * STEP)
        byte(good)
        break
    good = b
print('%s RESULT: byte %d set (start %d)' % (J, byte(), start), flush=True)
