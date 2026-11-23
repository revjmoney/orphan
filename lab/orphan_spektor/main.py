"""[orphan] ORPHAN LOGIC LAB: SPEKTOR / INJEKTOR 3000 -- the web service (port 8000).
SPEKTOR: a 16-channel logic analyzer in the S9 control board's FPGA (spektor.v). The page shows the waveforms,
sets the 4-stage trigger, decodes UART / I2C / SPI in the browser and exports VCD for PulseView.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import http.server
import json
import os
import threading
import time

import numpy as np

from spektor_hw import DEFAULT_MAP, PIN_NAMES, Spektor, to_vcd

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
CLK = 100e6
hw = Spektor()
lock = threading.Lock()
last = {'values': [], 'counts': [], 'trig': None, 'rate': 0, 'rle': False, 'time': 0, 'names': [], 'gen': 0}
run = {'gen': 0, 'grabbed': 0}           # arm bumps gen; the watcher reads each finished capture once
NAMES_FILE = os.path.join(HERE, 'names.local.json')
MAP_FILE = os.path.join(HERE, 'map.local.json')      # the channel map (which header pin each channel samples)


def load_map():
    try:
        return hw.set_map(json.load(open(MAP_FILE)))
    except (OSError, ValueError, TypeError):
        return hw.set_map(DEFAULT_MAP)


load_map()


def names():
    try:
        n = json.load(open(NAMES_FILE))
        return [str(x)[:16] for x in n][:16] + ['CH%d' % i for i in range(len(n), 16)]
    except (OSError, ValueError):
        return ['CH%d' % i for i in range(16)]


def grab():
    with lock:
        v, c, t, rle = hw.read()
    div = hw.rd(2)
    run['grabbed'] = run['gen']
    last.update(values=v.tolist(), counts=c.tolist(), trig=t, rate=CLK / (div + 1), rle=rle, time=time.time(),
                names=names(), gen=run['gen'])


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def send(self, code, body, kind='application/json', extra=()):
        b = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(b)))
        for k, v in extra:
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        if self.path.startswith('/api/status'):
            with lock:
                s = hw.status()
                s['map'], s['pins'] = hw.get_map(), hw.raw_pins()
            s['pin_names'] = PIN_NAMES
            s['rate'] = CLK / (hw.rd(2) + 1)
            s['names'] = names()
            try:
                s['temp'] = round(int(open('/sys/bus/iio/devices/iio:device0/in_temp0_raw').read()) * 503.975 / 4096 - 273.15, 1)
            except (OSError, ValueError):
                s['temp'] = None
            return self.send(200, s)
        if self.path.startswith('/api/capture'):
            return self.send(200, last)
        if self.path.startswith('/api/vcd'):
            vcd = to_vcd(np.array(last['values'], np.uint16), np.array(last['counts'], np.int64), last['rate'] or CLK,
                         last['names'] or names(), last['trig']).encode()
            return self.send(200, vcd, 'text/plain', [('Content-Disposition', 'attachment; filename="spektor-%s.vcd"'
                                                         % time.strftime('%Y%m%d-%H%M%S'))])
        return self.send(200, open(os.path.join(HERE, 'index.html'), 'rb').read(), 'text/html; charset=utf-8')

    def do_POST(self):
        try:
            d = json.loads(self.rfile.read(int(self.headers.get('Content-Length', 0))) or b'{}')
            a = d.get('action')
            if a == 'arm':
                with lock:
                    hw.arm(div=int(d.get('div', 0)), rle=bool(d.get('rle')), test=bool(d.get('test')),
                           post=int(d.get('post', 8192)), stages=d.get('stages') or ())
                    run['gen'] += 1
                last.update(values=[], counts=[], trig=None)
            elif a == 'force':
                with lock:
                    hw.force()
            elif a == 'stop':
                with lock:
                    hw.stop()
                grab()
            elif a == 'fetch':
                grab()
            elif a == 'map':
                with lock:
                    m = hw.set_map(d.get('map') or DEFAULT_MAP)
                json.dump(m, open(MAP_FILE, 'w'))
            elif a == 'names':
                json.dump([str(x)[:16] for x in d.get('names', [])][:16], open(NAMES_FILE, 'w'))
            else:
                raise ValueError('unknown action')
            self.send(200, {'ok': True, 'gen': run['gen']})
        except Exception as e:  # noqa: BLE001
            self.send(400, {'error': str(e)})


def watcher():
    """When a capture finishes, read it back so the page can show it."""
    while True:
        time.sleep(0.05)
        with lock:
            s = hw.status()
        if s['done'] and run['grabbed'] != run['gen']:
            grab()


threading.Thread(target=watcher, daemon=True).start()
print('[orphan] ORPHAN LOGIC LAB: SPEKTOR / INJEKTOR 3000 | by JMSCNC, makers of RotatoCAM | port %d' % PORT, flush=True)
http.server.ThreadingHTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
