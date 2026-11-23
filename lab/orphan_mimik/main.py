"""[orphan] MIMIK: the chip emulator. The web service (port 8000).
The FPGA answers as an I2C memory chip (a 24Cxx EEPROM) on the S9's own I2C bus or any header pins. The page loads
chip models, shows the wiring, every bus access live with a hit map, and the image as a hex editor. What the bus
master writes is kept like in a real EEPROM (saved to image.local.bin a moment after the writes stop).
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import http.server
import json
import math
import os
import random
import threading
import time
import urllib.parse

from mimik_hw import IMAGE, PIN_NAMES, Mimik, list_models

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
STATE_FILE = os.path.join(HERE, 'mimik.local.json')
IMAGE_FILE = os.path.join(HERE, 'image.local.bin')
hw = Mimik()
lock = threading.Lock()
log = {'seq': 0, 'events': [], 'reads': bytearray(IMAGE), 'writes': bytearray(IMAGE)}
dirty = {'at': 0.0}
CONTROLS_FILE = os.path.join(HERE, 'controls.local.json')
ctl = {}                  # sensor chips: id -> {value, mode, amp, period} (the values the page controls)
MODES = ('fixed', 'sine', 'ramp', 'square', 'noise')


def controls_reset():
    """The controls of the loaded model, with what was saved for it last time."""
    ctl.clear()
    try:
        saved = json.load(open(CONTROLS_FILE)).get((hw.model or {}).get('id'), {})
    except (OSError, ValueError):
        saved = {}
    for c in (hw.model or {}).get('controls', []):
        st = {'value': c['default'], 'mode': 'fixed', 'amp': (c['max'] - c['min']) / 10, 'period': 10.0}
        st.update({k: v for k, v in saved.get(c['id'], {}).items() if k in st})
        ctl[c['id']] = st


def controls_save():
    try:
        allm = json.load(open(CONTROLS_FILE))
    except (OSError, ValueError):
        allm = {}
    allm[(hw.model or {}).get('id')] = ctl
    json.dump(allm, open(CONTROLS_FILE, 'w'))


def control_values(t):
    """Every control's value now: fixed, or moving around its slider value."""
    out = {}
    for c in (hw.model or {}).get('controls', []):
        st = ctl.get(c['id'], {'value': c['default'], 'mode': 'fixed', 'amp': 0, 'period': 10})
        v, a, per = float(st['value']), float(st['amp']), max(0.1, float(st['period']))
        ph = (t % per) / per
        if st['mode'] == 'sine':
            v += a * math.sin(2 * math.pi * ph)
        elif st['mode'] == 'ramp':
            v += a * (2 * ph - 1)
        elif st['mode'] == 'square':
            v += a if ph < 0.5 else -a
        elif st['mode'] == 'noise':
            v += random.uniform(-a, a)
        out[c['id']] = max(c['min'], min(c['max'], v))
    return out


now_values = {}


def sensor_loop():
    """20 times a second: the sensor model turns the values into its register bytes."""
    while True:
        time.sleep(0.05)
        p = hw.plugin
        if p is None or not hasattr(p, 'update'):
            continue
        v = control_values(time.time())
        try:
            with lock:
                p.update(hw, v)
            now_values.clear()
            now_values.update(v)
        except Exception as e:  # noqa: BLE001
            print('model update failed:', e, flush=True)
            time.sleep(1)


def models():
    return {m['id']: m for m in list_models()}


def save_state():
    s = hw.settings()
    json.dump({'model': (hw.model or {}).get('id', '24c02'), 'settings': s}, open(STATE_FILE, 'w'))


def save_image():
    with lock:
        n = hw.settings()['size']
        img = hw.read_image(n)
    with open(IMAGE_FILE + '.part', 'wb') as f:
        f.write(img)
    os.replace(IMAGE_FILE + '.part', IMAGE_FILE)


def apply_settings(d):
    s = hw.settings()
    for k in ('address', 'address_mask', 'size', 'page', 'address_bytes', 'write_cycle_us', 'scl', 'sda'):
        if k in d:
            s[k] = int(str(d[k]), 0)
    for k in ('wp', 'enable'):
        if k in d:
            s[k] = bool(d[k])
    if not (0x08 <= s['address'] <= 0x77):
        raise ValueError('address must be 0x08..0x77')
    if not (0 <= s['scl'] < len(PIN_NAMES) and 0 <= s['sda'] < len(PIN_NAMES)) or s['scl'] == s['sda']:
        raise ValueError('SCL and SDA must be two different pins')
    hw.configure(dev=s['address'], devmask=s['address_mask'], size=s['size'], page=s['page'],
                 addr_bytes=s['address_bytes'], wp=s['wp'], twr_us=max(0, min(65535, s['write_cycle_us'])),
                 enable=s['enable'], scl=s['scl'], sda=s['sda'])
    if hw.model:
        hw.model['config'].update({k: s[k] for k in ('scl', 'sda')})


def startup():
    try:
        st = json.load(open(STATE_FILE))
        mid = st['model'] if st['model'] in models() else '24c02'
    except (OSError, ValueError, KeyError):
        st, mid = {}, '24c02'
    img = open(IMAGE_FILE, 'rb').read() if os.path.isfile(IMAGE_FILE) else None
    hw.load_model(mid, image=img)
    if st.get('settings'):
        apply_settings(st['settings'])
    hw.events()
    hw.clear_counts()
    controls_reset()


def watcher():
    """Drain the FPGA's event log (512 deep) into the page's log and the hit map; save the image after writes."""
    while True:
        time.sleep(0.02)
        with lock:
            ev = hw.events()
        if ev:
            now = time.time()
            for e in ev:
                log['seq'] += 1
                e['seq'], e['t'] = log['seq'], now
                if e['kind'] == 'READ':
                    log['reads'][e['addr']] = min(255, log['reads'][e['addr']] + 1)
                elif e['kind'] == 'WRITE':
                    log['writes'][e['addr']] = min(255, log['writes'][e['addr']] + 1)
                    dirty['at'] = now
            log['events'] = (log['events'] + ev)[-2000:]
            p = hw.plugin
            if p is not None and hasattr(p, 'on_event'):
                v = control_values(now)
                for e in ev:
                    try:
                        with lock:
                            p.on_event(hw, e, v)
                    except Exception as x:  # noqa: BLE001
                        print('model event failed:', x, flush=True)
        if dirty['at'] and time.time() - dirty['at'] > 1.0:
            dirty['at'] = 0.0
            try:
                save_image()
            except OSError as e:
                print('image save failed:', e, flush=True)


def self_test():
    """The board's own I2C master reads the chip through the real pins, like any MCU would."""
    s = hw.settings()
    if (s['scl'], s['sda']) != (36, 37):
        return {'ok': False, 'text': 'The self-test master sits on the board I2C bus: set SCL / SDA to I2C SCL / I2C SDA.'}
    w = s['register_width']
    with lock:
        found = hw.m_scan()
        n = min(s['size'], 256)
        img = hw.read_image(n)
        if s['address'] not in found:
            got = b''
        elif w == 1:
            got = hw.m_read(s['address'], 0, n, 400, s['address_bytes'])
        else:                                        # a register chip: read each register on its own
            got = b''.join(hw.m_read(s['address'], r, w, 400) for r in range(n // w))
    ok = got == img
    return {'ok': ok, 'found': found, 'text': 'scan: %s | read %d bytes at 400 kHz through the pins: %s' % (
        ' '.join('0x%02x' % a for a in found) or 'nothing', n, 'MATCHES the image' if ok else 'DIFFERENT')}


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def send(self, code, body, kind='application/json', extra=()):
        b = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(b)))
        self.send_header('Cache-Control', 'no-store')
        for k, v in extra:
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        u = urllib.parse.urlparse(self.path)
        q = dict(urllib.parse.parse_qsl(u.query))
        if u.path == '/api/status':
            with lock:
                s = {'settings': hw.settings(), 'status': hw.status()}
            s['model'] = hw.model
            s['pins'] = PIN_NAMES
            s['controls'] = ctl
            s['values'] = dict(now_values)
            try:
                s['temp'] = round(int(open('/sys/bus/iio/devices/iio:device0/in_temp0_raw').read()) * 503.975 / 4096
                                  - 273.15, 1)
            except (OSError, ValueError):
                s['temp'] = None
            return self.send(200, s)
        if u.path == '/api/models':
            return self.send(200, list(models().values()))
        if u.path == '/api/events':
            since = int(q.get('since', 0))
            return self.send(200, {'seq': log['seq'], 'events': [e for e in log['events'] if e['seq'] > since][-500:]})
        if u.path == '/api/hits':
            at, n = int(q.get('at', 0)) % IMAGE, max(1, min(4096, int(q.get('n', 256))))
            return self.send(200, {'at': at, 'reads': list(log['reads'][at:at + n]),
                                   'writes': list(log['writes'][at:at + n])})
        if u.path == '/api/image':
            at, n = int(q.get('at', 0)) % IMAGE, max(1, min(IMAGE, int(q.get('n', 256))))
            with lock:
                b = hw.read_image(min(n, IMAGE - at), at)
            return self.send(200, {'at': at, 'hex': b.hex()})
        if u.path == '/api/image.bin':
            with lock:
                n = hw.settings()['size']
                b = hw.read_image(n)
            name = 'mimik-%s-%s.bin' % ((hw.model or {}).get('id', 'chip'), time.strftime('%Y%m%d-%H%M%S'))
            return self.send(200, b, 'application/octet-stream', [('Content-Disposition', 'attachment; filename="%s"'
                                                                     % name)])
        return self.send(200, open(os.path.join(HERE, 'index.html'), 'rb').read(), 'text/html; charset=utf-8')

    def do_POST(self):
        u = urllib.parse.urlparse(self.path)
        try:
            n = int(self.headers.get('Content-Length', 0))
            if n > IMAGE + 4096:
                raise ValueError('too big')
            raw = self.rfile.read(n)
            if u.path == '/api/image.bin':                   # a whole image file (raw bytes)
                at = int(dict(urllib.parse.parse_qsl(u.query)).get('at', 0))
                if not (0 <= at < IMAGE) or at + len(raw) > IMAGE:
                    raise ValueError('image does not fit in 32 KB')
                with lock:
                    hw.write_image(raw, at)
                save_image()
                return self.send(200, {'ok': True, 'bytes': len(raw)})
            d = json.loads(raw or b'{}')
            a = d.get('action')
            res = {'ok': True}
            if a == 'load':
                mid = d.get('model')
                if mid not in models():
                    raise ValueError('no such model')
                with lock:
                    hw.load_model(mid, image=None if d.get('blank') else
                                  (open(IMAGE_FILE, 'rb').read() if os.path.isfile(IMAGE_FILE) else None))
                    hw.events()
                    hw.clear_counts()
                controls_reset()
                save_state()
                save_image()
            elif a == 'settings':
                with lock:
                    apply_settings(d.get('settings') or {})
                save_state()
            elif a == 'poke':
                at = int(d['at'])
                data = bytes(int(x) & 0xFF for x in d.get('bytes', []))[:4096]
                if not (0 <= at < IMAGE) or at + len(data) > IMAGE:
                    raise ValueError('outside the image')
                with lock:
                    hw.write_image(data, at)
                save_image()
            elif a == 'fill':
                v = int(d.get('value', 255)) & 0xFF
                with lock:
                    hw.write_image(bytes([v]) * hw.settings()['size'])
                save_image()
            elif a == 'clear':
                with lock:
                    hw.clear_counts()
                log['events'] = []
                log['reads'][:] = bytes(IMAGE)
                log['writes'][:] = bytes(IMAGE)
            elif a == 'control':
                cid = d.get('id')
                if cid not in ctl:
                    raise ValueError('no such control')
                for k in ('value', 'amp', 'period'):
                    if k in d:
                        ctl[cid][k] = float(d[k])
                if 'mode' in d:
                    if d['mode'] not in MODES:
                        raise ValueError('mode: ' + ', '.join(MODES))
                    ctl[cid]['mode'] = d['mode']
                controls_save()
            elif a == 'selftest':
                res = self_test()
            else:
                raise ValueError('unknown action')
            self.send(200, res)
        except Exception as e:  # noqa: BLE001
            self.send(400, {'error': str(e)})


startup()
threading.Thread(target=watcher, daemon=True).start()
threading.Thread(target=sensor_loop, daemon=True).start()
print('[orphan] MIMIK: the chip emulator | by JMSCNC, makers of RotatoCAM | port %d' % PORT, flush=True)
http.server.ThreadingHTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
