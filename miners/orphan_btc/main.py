"""[orphan] Orphan BTC: a real Stratum Bitcoin miner on the S9 control board's FPGA.

Roots: the SHA-256 hardware is Ardzy's 13_sha256 lab (by chryso, GPL-3.0): 4 double-SHA-256 units at 100 MHz,
about 1.1 MH/s. Orphan adds the pool side: Stratum v1, coinbase + merkle root, extranonce2 rolling, every result
re-checked on the ARM against the exact share target, a 3 % opt-out dev fee (devfee.py) and this web page (port 8000).
At about 1 MH/s this is a lottery miner (solo pools such as public-pool.io): a block is astronomically unlikely, but
every share it sends is real work. by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import collections
import http.server
import json
import os
import threading
import time
import traceback

import devfee
import settings
from blocks import Bus, ShaMiner, require
from stratum_btc import Session

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000


def build_info():
    """What the bitstream uses and how fast it can run (the FPGA build report next to it), for the page's floorplan."""
    try:
        for v in json.load(open(os.path.join(HERE, '.ardzy_build.json'))).values():
            r = v.get('report') if isinstance(v, dict) else None
            if r:
                c = r.get('clocks', {}).get('clk', {})
                return {'used': r.get('used', {}), 'max': r.get('max', {}), 'fmax': c.get('fmax'), 'need': c.get('need')}
    except (OSError, ValueError, AttributeError):
        pass
    return None


BUILD = build_info()


class Control:
    def __init__(self):
        self.lock, self.cancel = threading.Lock(), threading.Event()
        self.log = collections.deque(maxlen=300)
        self.seq = 0
        self.state = {'mode': 'idle', 'message': 'Ready', 'mining': {}, 'rate': 0, 'hashes': 0,
                      'devfee': {'enabled': True, 'active': False, 'percent': devfee.PERCENT}}
        self.thread = None

    def update(self, log_message=None, **kw):
        with self.lock:
            if log_message:
                self.seq += 1
                self.log.append({'seq': self.seq, 'time': time.time(), 'message': log_message})
            if kw.get('message') and kw['message'] != self.state.get('message'):
                self.seq += 1
                self.log.append({'seq': self.seq, 'time': time.time(), 'message': kw['message']})
            self.state.update(kw)

    def snapshot(self):
        with self.lock:
            s = dict(self.state)
            s['log'] = list(self.log)
        s['settings'] = settings.public()
        s['build'] = BUILD
        try:
            s['temp'] = round(int(open('/sys/bus/iio/devices/iio:device0/in_temp0_raw').read()) * 503.975 / 4096 - 273.15, 1)
        except (OSError, ValueError):
            s['temp'] = None
        return s

    def mine(self):
        cfg = settings.load()
        if not cfg['wallet']:
            raise ValueError('Save your pool username or Bitcoin address first')
        sha = ShaMiner(bus, slot=1)
        fee = devfee.Schedule()
        self.update(mode='mine', message='Mining')
        while not self.cancel.is_set():
            role, secs = fee.next() if cfg['devfee'] else ('user', 3600)
            run = devfee.dev_settings(cfg, 'sha256') if role == 'dev' else cfg
            self.update(devfee={'enabled': cfg['devfee'], 'active': role == 'dev', 'percent': devfee.PERCENT},
                        log_message=('Dev fee: mining %d s for the Orphan developer (3 %%, opt-out in settings)' % secs)
                        if role == 'dev' else None)
            began = time.monotonic()
            try:
                Session(sha, run, self.cancel, self.update, until=began + secs).run()
            except Exception as e:  # noqa: BLE001
                self.update(message='%s; trying the pool again in 10 s' % e)
                if self.cancel.wait(10):
                    break
            finally:
                if cfg['devfee']:
                    fee.add(role, time.monotonic() - began)
        self.update(mode='idle', message='Mining stopped', rate=0,
                    devfee={'enabled': cfg['devfee'], 'active': False, 'percent': devfee.PERCENT})

    def start(self):
        if self.thread and self.thread.is_alive():
            return
        self.cancel.clear()

        def go():
            try:
                self.mine()
            except Exception as e:  # noqa: BLE001
                traceback.print_exc()
                self.update(mode='idle', message=str(e))
        self.thread = threading.Thread(target=go, daemon=True)
        self.thread.start()


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def send(self, code, body, kind='application/json'):
        b = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        if self.path == '/api/status':
            return self.send(200, control.snapshot())
        return self.send(200, open(os.path.join(HERE, 'index.html'), 'rb').read(), 'text/html; charset=utf-8')

    def do_POST(self):
        try:
            d = json.loads(self.rfile.read(int(self.headers.get('Content-Length', 0))) or b'{}')
            a = d.get('action')
            if a == 'mine':
                control.start()
            elif a == 'stop':
                control.cancel.set()
            elif a == 'settings':
                if control.thread and control.thread.is_alive():
                    raise ValueError('Stop mining before changing settings')
                new = dict(d.get('settings', {}))
                if not new.get('password'):
                    new['password'] = settings.load()['password']
                settings.save(new)
            elif a == 'fan':
                bus.wr(15, 1, max(0, min(100, int(d.get('duty', 0)))))
            else:
                raise ValueError('unknown action')
            self.send(200, {'ok': True})
        except Exception as e:  # noqa: BLE001
            self.send(400, {'error': str(e)})


def market():
    """Bitcoin's live tip height and USD price (mempool.space, public), to name the coin and price the estimate."""
    import urllib.request
    while True:
        try:
            h = int(urllib.request.urlopen('https://mempool.space/api/blocks/tip/height', timeout=10).read())
            p = json.loads(urllib.request.urlopen('https://mempool.space/api/v1/prices', timeout=10).read())
            control.update(market={'btc_height': h, 'btc_usd': p.get('USD'), 'time': time.time()})
        except Exception as e:  # noqa: BLE001
            control.update(market={'error': str(e)[:80], 'time': time.time()})
        time.sleep(300)


bus = Bus()
require(bus, 'SHA2')
control = Control()
threading.Thread(target=market, daemon=True).start()
print('[orphan] Orphan BTC | Stratum Bitcoin miner on Ardzy\'s SHA-256 core | by JMSCNC, makers of RotatoCAM | port %d' % PORT,
      flush=True)
if settings.load().get('autostart'):
    control.start()
http.server.ThreadingHTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
