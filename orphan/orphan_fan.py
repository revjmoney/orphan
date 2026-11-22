#!/usr/bin/env python3
"""orphan-fan: S9 fan control that works whatever FPGA project is loaded (JMSCNC, Rev. J. Money 2026).

Two ways to reach the fans, tried in order:
  1. Ardzy's web API, when its pin-control design (ardzy_io) is loaded.
  2. The orphan_fan block (slot 15, ID "FAN1") that every Orphan FPGA design carries.

  orphan-fan            show duty and rpm
  orphan-fan set 40     set 40 % (also saved to /etc/orphan/fan-duty)
  orphan-fan boot       apply the saved duty (used by s9-fan.service)
"""
import json
import mmap
import os
import struct
import sys
import time
import urllib.request

CONF = '/etc/orphan/fan-duty'
BASE = 0x43C00000 + 15 * 0x1000          # ardzy_bus slot 15
FAN_ID = 0x46414E31                       # "FAN1"


def _api(path, post=False):
    req = urllib.request.Request('http://127.0.0.1' + path, method='POST' if post else 'GET')
    with urllib.request.urlopen(req, timeout=4) as r:
        return json.load(r)


class _Block:
    def __init__(self):
        fd = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
        try:
            self.m = mmap.mmap(fd, 0x1000, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=BASE)
        finally:
            os.close(fd)

    def rd(self, i):
        return struct.unpack_from('<I', self.m, 4 * i)[0]

    def wr(self, i, v):
        struct.pack_into('<I', self.m, 4 * i, v & 0xFFFFFFFF)


def _fpga_ready():
    try:
        return open('/sys/class/fpga_manager/fpga0/state').read().strip() == 'operating'
    except OSError:
        return False


def _block():
    """The FAN1 block, or None. Only touch the bus when an FPGA design is running (else the read hangs)."""
    if not _fpga_ready():
        return None
    try:
        b = _Block()
        return b if b.rd(0) == FAN_ID else None
    except OSError:
        return None


def status():
    """{'via', 'on', 'duty', 'rpm': [6]} or raises RuntimeError with the reason."""
    try:
        io = _api('/api/io')
        if io.get('ok') is not False and io.get('fan'):
            f = io['fan']
            return {'via': 'Ardzy pin-control', 'on': bool(f.get('on')),
                    'duty': int(round(float(f.get('duty_pct', 0)))), 'rpm': (f.get('rpm') or [0] * 6)[:6]}
    except Exception:  # noqa: BLE001
        pass
    b = _block()
    if b is None:
        raise RuntimeError('no fan control in the loaded FPGA design (rebuild it with orphan_fan, slot 15)')
    return {'via': 'orphan_fan block', 'on': True, 'duty': b.rd(1), 'rpm': [b.rd(2 + i) * 30 for i in range(6)]}


def set_duty(d, save=True):
    d = max(0, min(100, int(d)))
    done = False
    try:
        r = _api('/api/io/fan?on=1&duty=%d' % d, post=True)
        done = r.get('ok') is not False
    except Exception:  # noqa: BLE001
        pass
    if not done:
        b = _block()
        if b is None:
            raise RuntimeError('no fan control in the loaded FPGA design')
        b.wr(1, d)
    if save:
        os.makedirs(os.path.dirname(CONF), exist_ok=True)
        with open(CONF, 'w') as fh:
            fh.write('%d\n' % d)
    return d


def saved():
    try:
        return int(open(CONF).read().strip() or 0)
    except (OSError, ValueError):
        return 0


def main(argv):
    if argv[:1] == ['set'] and len(argv) > 1:
        print('fan duty %d%%' % set_duty(argv[1]))
    elif argv[:1] == ['boot']:
        for _ in range(60):                    # wait for the web server / FPGA after boot
            try:
                set_duty(saved(), save=False)
                print('fan duty %d%% (saved)' % saved())
                return 0
            except RuntimeError:
                time.sleep(2)
        print('orphan-fan: no fan control found')
        return 1
    else:
        try:
            s = status()
        except RuntimeError as e:
            print('orphan-fan:', e)
            return 1
        print('fan duty %d%% via %s' % (s['duty'], s['via']))
        for i, r in enumerate(s['rpm']):
            print('  FAN%d %s' % (i + 1, ('%d rpm' % r) if r else '-'))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
