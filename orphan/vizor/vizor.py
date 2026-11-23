#!/usr/bin/env python3
"""VIZOR: the Orphan desktop in your browser (http://<board>:8080).

One small service, Python standard library only:
  /                 the desktop page (index.html)
  /api/sys          CPU, memory, temperature, network, fans, the loaded core (polled by the tray)
  /api/projects     every FPGA project with its project.json (title, branch, quick start, web port)
  /api/app          the loaded core's own /api/status on port 8000 (hashrate and such for the tray)
  /ardzy/...        a pass-through to the Ardzy board API on port 80 (load / stop cores, logs, processes)
  /ws/shell         a real login shell over a WebSocket (xterm.js on the page). LAN addresses only, and only
                    from pages served by this board (Origin check), so other web sites cannot open it.
  /ws/screen        the X DESKTOP: Xvfb's screen as changed 16 x 16 tiles (zlib), mouse and keys back (XTest)
  /api/x/run        start an X program (PulseView, GTKWave, xterm) on that screen
  /fan.js           the fan slider every Orphan page puts in its header (it talks to /api/fan, from any port of
                    this board)
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
"""
import base64
import fcntl
import hashlib
import http.server
import ipaddress
import json
import os
import pty
import select
import signal
import socket
import struct
import subprocess
import sys
import termios
import zlib
import threading
import time
import urllib.error
import urllib.parse
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = int(os.environ.get('VIZOR_PORT', '8080'))
PROJ = '/opt/ardzy/projects'
STATE = '/var/lib/ardzy'
ARDZY = 'http://127.0.0.1:80'
APP = 'http://127.0.0.1:8000'
CONF = '/etc/orphan/vizor.json'          # {"shell": true}
VERSION = '1.0'
sys.path.insert(0, '/usr/local/share/orphan')
sys.path.insert(0, HERE)


def read(p, default=''):
    try:
        with open(p) as f:
            return f.read().strip()
    except OSError:
        return default


def conf():
    try:
        return dict({'shell': True}, **json.load(open(CONF)))
    except (OSError, ValueError):
        return {'shell': True}


# ---------------------------------------------------------------- system stats
class Sampler:
    """CPU and network rates need two readings: a background thread keeps the last second's numbers."""

    def __init__(self):
        self.cpu = 0.0
        self.rx = self.tx = 0.0
        self.fan = None
        threading.Thread(target=self.run, daemon=True).start()

    @staticmethod
    def _cpu():
        v = [int(x) for x in read('/proc/stat').splitlines()[0].split()[1:]]
        return sum(v), v[3] + (v[4] if len(v) > 4 else 0)

    @staticmethod
    def _net():
        rx = tx = 0
        for l in read('/proc/net/dev').splitlines()[2:]:
            name, data = l.split(':', 1)
            if name.strip() == 'lo':
                continue
            f = data.split()
            rx, tx = rx + int(f[0]), tx + int(f[8])
        return rx, tx

    def run(self):
        t0, i0 = self._cpu()
        r0, x0 = self._net()
        n = 0
        while True:
            time.sleep(1)
            t1, i1 = self._cpu()
            r1, x1 = self._net()
            self.cpu = 100.0 * (1 - (i1 - i0) / max(1, t1 - t0))
            self.rx, self.tx = r1 - r0, x1 - x0
            t0, i0, r0, x0 = t1, i1, r1, x1
            if n % 5 == 0:                         # fans: every 5 s (it may ask the Ardzy API)
                try:
                    import orphan_fan
                    self.fan = orphan_fan.status()
                except Exception as e:  # noqa: BLE001
                    self.fan = {'error': str(e)[:80]}
            n += 1


def temperature():
    raw = read('/sys/bus/iio/devices/iio:device0/in_temp0_raw')
    if not raw:
        return None
    off = float(read('/sys/bus/iio/devices/iio:device0/in_temp0_offset', '0') or 0)
    sc = float(read('/sys/bus/iio/devices/iio:device0/in_temp0_scale', '1') or 1)
    return round((int(raw) + off) * sc / 1000, 1)


def sysinfo():
    mem = {l.split(':')[0]: int(l.split()[1]) for l in open('/proc/meminfo') if ':' in l}
    st = os.statvfs('/')
    ips = subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split()
    cur = read(STATE + '/current')
    return {
        'host': socket.gethostname(), 'ips': [i for i in ips if ':' not in i],
        'uptime': float(read('/proc/uptime', '0').split()[0]), 'load': os.getloadavg(),
        'cpu': round(S.cpu, 1), 'temp': temperature(),
        'mem_used': (mem['MemTotal'] - mem['MemAvailable']) // 1024, 'mem_total': mem['MemTotal'] // 1024,
        'disk_free_gb': round(st.f_bavail * st.f_frsize / 2**30, 2), 'rx': S.rx, 'tx': S.tx, 'fan': S.fan,
        'core': cur, 'core_running': subprocess.run(['systemctl', 'is-active', '--quiet', 'ardzy-app']).returncode == 0,
        'fpga': read('/sys/class/fpga_manager/fpga0/state'), 'kernel': os.uname().release,
        'os': next((l.split('=', 1)[1].strip().strip('"') for l in open('/etc/os-release')
                    if l.startswith('PRETTY_NAME=')), ''),
        'shell': bool(conf().get('shell')), 'vizor': VERSION, 'time': time.time()}


def projects():
    out = []
    for n in sorted(os.listdir(PROJ)) if os.path.isdir(PROJ) else []:
        d = os.path.join(PROJ, n)
        if not os.path.isdir(d):
            continue
        try:
            m = json.load(open(os.path.join(d, 'project.json')))
        except (OSError, ValueError):
            m = {}
        out.append({'name': n, 'owner': 'orphan' if n.startswith('orphan_') else 'ardzy',
                    'title': m.get('title', n), 'branch': m.get('branch', ''), 'category': m.get('category', ''),
                    'summary': m.get('summary', ''), 'quickstart': m.get('quickstart', []),
                    'web': m.get('web'), 'runs': m.get('runs', ''),
                    'guide': os.path.exists(os.path.join(d, 'guide.html'))})
    return out


def lan(addr):
    try:
        a = ipaddress.ip_address(addr)
        return a.is_private or a.is_loopback or a.is_link_local
    except ValueError:
        return False


# ---------------------------------------------------------------- the shell (WebSocket + pty)
GUID = b'258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
# what a terminal window may start with (anything else = a plain shell); each drops to a shell afterwards
RUN = {'menu': 'orphan', 'htop': 'htop', 'mc': 'mc', 'info': 'fastfetch', 'net': 'ip -br addr; echo; ip route; echo; ping -c 3 1.1.1.1',
       'fan': 'orphan-fan', 'logs': 'journalctl -u ardzy-app -f -n 50'}


def ws_recv(sock):
    """One client frame: (opcode, payload). Client frames are always masked."""
    def need(n):
        b = b''
        while len(b) < n:
            c = sock.recv(n - len(b))
            if not c:
                raise ConnectionError
            b += c
        return b
    h = need(2)
    op, ln = h[0] & 15, h[1] & 127
    if ln == 126:
        ln = struct.unpack('>H', need(2))[0]
    elif ln == 127:
        ln = struct.unpack('>Q', need(8))[0]
    mask = need(4) if h[1] & 128 else b'\0\0\0\0'
    data = bytearray(need(ln))
    for i in range(ln):
        data[i] ^= mask[i & 3]
    return op, bytes(data)


def ws_send(sock, data, op=2):
    n = len(data)
    head = bytes([128 | op]) + (bytes([n]) if n < 126 else bytes([126]) + struct.pack('>H', n) if n < 65536
                                else bytes([127]) + struct.pack('>Q', n))
    sock.sendall(head + data)


def shell(handler, run=''):
    sock = handler.connection
    pid, fd = pty.fork()
    if pid == 0:                                       # the child: a login shell in /root
        os.environ.update(TERM='xterm-256color', COLORTERM='truecolor', VIZOR='1', HOME='/root', ORPHAN_NOMENU='1')
        os.chdir('/root')
        if run in RUN:
            os.execvp('/bin/bash', ['bash', '-lc', RUN[run] + '; exec bash -l'])
        os.execvp('/bin/bash', ['bash', '-l'])
    wlock = threading.Lock()
    alive = [True]

    def pump():                                        # shell output -> browser
        try:
            while alive[0]:
                r, _, _ = select.select([fd], [], [], 0.5)
                if fd in r:
                    data = os.read(fd, 65536)
                    if not data:
                        break
                    with wlock:
                        ws_send(sock, data)
        except (OSError, ConnectionError):
            pass
        alive[0] = False
        try:
            with wlock:
                ws_send(sock, b'', 8)
        except OSError:
            pass
    threading.Thread(target=pump, daemon=True).start()
    try:
        while alive[0]:
            op, data = ws_recv(sock)
            if op == 8:
                break
            if op == 9:
                with wlock:
                    ws_send(sock, data, 10)
            elif op == 1 and data[:1] == b'{':         # control: {"r": [cols, rows]}
                m = json.loads(data)
                if 'r' in m:
                    fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack('HHHH', int(m['r'][1]), int(m['r'][0]), 0, 0))
            elif op in (1, 2):
                os.write(fd, data)
    except (OSError, ConnectionError, ValueError):
        pass
    alive[0] = False
    try:
        os.kill(pid, signal.SIGHUP)
        os.waitpid(pid, 0)
    except OSError:
        pass
    os.close(fd)


# ---------------------------------------------------------------- the X desktop (Xvfb tiles + XTest input)
XFB = '/dev/shm/Xvfb_screen0'
TILE = 16
X_APPS = {'pulseview': ['pulseview'], 'gtkwave': ['gtkwave'],
          'xterm': ['xterm', '-bg', '#050806', '-fg', '#d8ead1', '-cr', '#d2ff51', '-fa', 'DejaVu Sans Mono', '-fs', '11']}
X_ENV = dict(os.environ, DISPLAY=':1', HOME='/root', QT_XCB_GL_INTEGRATION='none', LIBGL_ALWAYS_SOFTWARE='1',
             NO_AT_BRIDGE='1')


def x_start():
    """Start Xvfb + JWM (vizor-x.service) if needed; wait for the screen file."""
    if not os.path.exists(XFB) or subprocess.run(['systemctl', 'is-active', '--quiet', 'vizor-x']).returncode:
        subprocess.run(['systemctl', 'start', 'vizor-x'])
    for _ in range(80):
        if os.path.exists(XFB) and os.path.getsize(XFB) > 4096:
            return True
        time.sleep(0.1)
    return False


def x_frame():
    """Xvfb's screen file (XWD format): (width, height, numpy uint16 array view)."""
    import numpy as np
    with open(XFB, 'rb') as f:
        head = f.read(100)
    be = struct.unpack('>I', head[:4])[0] < 4096
    v = struct.unpack(('>' if be else '<') + '25I', head)
    hsize, depth, w, h, bpp, bpl, ncolors = v[0], v[3], v[4], v[5], v[11], v[12], v[19]
    if bpp != 16:
        raise RuntimeError('VIZOR X needs a 16-bit screen (Xvfb ...x16), this one is %d bits' % bpp)
    off = hsize + ncolors * 12
    mm = np.memmap(XFB, dtype='<u2', mode='r', offset=off, shape=(h, bpl // 2))
    return w, h, mm[:, :w]


def screen(handler):
    import numpy as np
    sock = handler.connection
    if not x_start():
        ws_send(sock, json.dumps({'error': 'the X screen did not start (journalctl -u vizor-x)'}).encode(), 1)
        return
    w, h, fb = x_frame()
    tw, th = w // TILE, h // TILE
    ws_send(sock, json.dumps({'w': tw * TILE, 'h': th * TILE, 'tile': TILE}).encode(), 1)
    wlock = threading.Lock()
    alive = [True]
    want_full = [True]
    stats = {'frames': 0, 'tiles': 0, 'bytes': 0, 'ms': 0.0}

    def stream():
        prev = None
        try:
            while alive[0]:
                t0 = time.time()
                cur = np.array(fb[:th * TILE, :tw * TILE])
                t4 = cur.reshape(th, TILE, tw, TILE)
                if prev is None or want_full[0]:
                    dirty = np.ones((th, tw), bool)
                    want_full[0] = False
                else:
                    dirty = (cur != prev).reshape(th, TILE, tw, TILE).any(axis=(1, 3))
                prev = cur
                n = int(dirty.sum())
                if n:
                    ys, xs = np.nonzero(dirty)
                    tiles = t4.transpose(0, 2, 1, 3)[dirty]              # (n, 16, 16)
                    pos = np.empty(2 * n, np.uint8)
                    pos[0::2], pos[1::2] = xs, ys
                    msg = zlib.compress(struct.pack('<H', n) + pos.tobytes() + tiles.astype('<u2').tobytes(), 1)
                    with wlock:
                        ws_send(sock, msg)
                    stats['frames'] += 1
                    stats['tiles'] += n
                    stats['bytes'] += len(msg)
                stats['ms'] = (time.time() - t0) * 1000
                time.sleep(max(0.0, 0.05 - (time.time() - t0)))     # at most 20 scans a second
        except (OSError, ConnectionError):
            pass
        alive[0] = False
    threading.Thread(target=stream, daemon=True).start()

    from Xlib import X, display as xdisplay
    from Xlib.ext import xtest
    d = xdisplay.Display(':1')
    try:
        while alive[0]:
            op, data = ws_recv(sock)
            if op == 8:
                break
            if op == 9:
                with wlock:
                    ws_send(sock, data, 10)
                continue
            if op != 1:
                continue
            m = json.loads(data)
            if 'm' in m:                                          # pointer moves: [x, y]
                xtest.fake_input(d, X.MotionNotify, x=int(m['m'][0]), y=int(m['m'][1]))
            if 'b' in m:                                          # button [n, down]
                xtest.fake_input(d, X.ButtonPress if m['b'][1] else X.ButtonRelease, int(m['b'][0]))
            if 'k' in m:                                          # key [keysym, down]
                kc = d.keysym_to_keycode(int(m['k'][0]))
                if kc:
                    xtest.fake_input(d, X.KeyPress if m['k'][1] else X.KeyRelease, kc)
            if 'full' in m:
                want_full[0] = True
            if 'stats' in m:
                with wlock:
                    ws_send(sock, json.dumps({'stats': stats}).encode(), 1)
            d.sync()
    except (OSError, ConnectionError, ValueError):
        pass
    alive[0] = False
    d.close()


def x_run(app):
    """An X program: one of X_APPS, or the id of any installed .desktop launcher (xapps.py)."""
    import shlex
    import xapps
    if app in X_APPS:
        cmd = X_APPS[app]
    else:
        a = next((a for a in xapps.apps() if a['id'] == app), None)
        if a is None:
            raise ValueError('no installed program called %r' % app)
        cmd = shlex.split(xapps.command(a))
    if not x_start():
        raise RuntimeError('the X screen did not start')
    subprocess.Popen(cmd, env=X_ENV, cwd='/root', stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                     stderr=subprocess.DEVNULL, start_new_session=True)
    return app


X_ENVFILE = '/etc/orphan/vizor-x.env'
X_SIZES = ['1024x600', '1280x720', '1366x768', '1600x900', '1920x1080']


def x_settings(new=None):
    """X SETTINGS: screen size, DPI, keyboard layout, background. Saving restarts the X screen."""
    import re
    cur = {'size': '1280x720', 'dpi': '96', 'kbd': '', 'bg': '#060809'}
    for line in read(X_ENVFILE).splitlines():
        if '=' in line:
            k, v = line.split('=', 1)
            cur[k.replace('VIZOR_X_', '').lower()] = v.strip().strip('"')
    if new:
        if new.get('size') in X_SIZES:
            cur['size'] = new['size']
        if str(new.get('dpi', '')).isdigit() and 60 <= int(new['dpi']) <= 200:
            cur['dpi'] = str(int(new['dpi']))
        if re.fullmatch(r'[a-z]{0,8}', str(new.get('kbd', cur['kbd']))):
            cur['kbd'] = str(new.get('kbd', cur['kbd']))
        if re.fullmatch(r'#[0-9a-fA-F]{6}', str(new.get('bg', ''))):
            cur['bg'] = new['bg']
        os.makedirs(os.path.dirname(X_ENVFILE), exist_ok=True)
        with open(X_ENVFILE, 'w') as f:
            f.write(''.join('VIZOR_X_%s="%s"\n' % (k.upper(), v) for k, v in cur.items()))
        subprocess.run(['systemctl', 'restart', 'vizor-x'])
    cur['sizes'] = X_SIZES
    cur['running'] = subprocess.run(['systemctl', 'is-active', '--quiet', 'vizor-x']).returncode == 0
    return cur


# ---------------------------------------------------------------- HTTP
class Handler(http.server.BaseHTTPRequestHandler):
    protocol_version = 'HTTP/1.1'

    def log_message(self, *a):
        pass

    def send(self, code, body, kind='application/json', extra=()):
        b = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(b)))
        self.send_header('Cache-Control', 'no-store')
        for k, v in extra:
            self.send_header(k, str(v).replace('\r', '').replace('\n', ''))
        self.end_headers()
        self.wfile.write(b)

    def proxy(self, base, path, method='GET', body=None):
        # only ever a path on the fixed local service: never let the request pick the host
        if base not in (APP, ARDZY) or not path.startswith('/') or path.startswith('//'):
            return self.send(400, {'ok': False, 'out': 'bad path'})
        try:
            req = urllib.request.Request(base + path, data=body, method=method,
                                         headers={'Content-Type': self.headers.get('Content-Type', 'application/json')})
            with urllib.request.urlopen(req, timeout=60) as r:
                return self.send(r.status, r.read(), r.headers.get('Content-Type', 'application/json'))
        except urllib.error.HTTPError as e:
            return self.send(e.code, e.read(), e.headers.get('Content-Type', 'application/json'))
        except (OSError, ValueError) as e:
            return self.send(502, {'ok': False, 'out': 'not reachable: %s' % e})

    def static(self, name, kind):
        p = os.path.join(HERE, name)
        if not os.path.isfile(p):
            return self.send(404, {'ok': False})
        return self.send(200, open(p, 'rb').read(), kind)

    def do_GET(self):
        if not lan(self.client_address[0]):
            return self.send(403, {'ok': False, 'out': 'VIZOR answers on the local network only'})
        p = self.path
        if p.startswith('/ws/shell'):
            return self.ws_shell()
        if p.startswith('/ws/screen'):
            return self.ws_upgrade(screen)
        if p == '/fan.js':
            return self.static('fan.js', 'text/javascript; charset=utf-8')
        if p == '/' or p.startswith('/?') or p.startswith('/#'):
            return self.static('index.html', 'text/html; charset=utf-8')
        if p == '/logo.png':
            return self.static('logo.png', 'image/png')
        if p.startswith('/api/sys'):
            return self.send(200, sysinfo(), extra=self.cors())
        if p.startswith('/api/fan'):
            return self.send(200, dict(S.fan or {}, ok=bool(S.fan and 'error' not in S.fan)), extra=self.cors())
        if p.startswith('/api/projects'):
            return self.send(200, {'projects': projects()})
        if p.startswith('/api/x/apps'):
            import xapps
            return self.send(200, {'apps': xapps.apps()})
        if p.startswith('/api/x/settings'):
            return self.send(200, x_settings())
        if p.startswith('/api/app'):
            return self.proxy(APP, '/api/status')
        if p.startswith('/ardzy/'):
            return self.proxy(ARDZY, p[len('/ardzy'):])
        return self.send(404, {'ok': False, 'out': 'not found'})

    def do_OPTIONS(self):                               # CORS preflight for the fan slider on other ports
        if not lan(self.client_address[0]) or not self.board_origin():
            return self.send(403, {'ok': False})
        return self.send(204, b'', 'text/plain', self.cors() + [('Access-Control-Allow-Methods', 'GET, POST'),
                                                                 ('Access-Control-Allow-Headers', 'Content-Type')])

    def cors(self):
        o = self.headers.get('Origin')
        return [('Access-Control-Allow-Origin', o), ('Vary', 'Origin')] if o and self.board_origin() else []

    def board_origin(self):
        """A page from this same board on any port (the cores' pages on 8000, the board page on 80)."""
        o = self.headers.get('Origin')
        if not o:
            return True
        host = (self.headers.get('Host') or '').lower().rsplit(':', 1)[0]
        return urllib.parse.urlparse(o.lower()).hostname == host.strip('[]')

    def do_POST(self):
        if not lan(self.client_address[0]):
            return self.send(403, {'ok': False})
        if self.path.startswith('/api/fan'):
            if not self.board_origin():
                return self.send(403, {'ok': False, 'out': 'cross-site request refused'})
            body = self.rfile.read(int(self.headers.get('Content-Length', 0) or 0))
            try:
                import orphan_fan
                d = orphan_fan.set_duty(json.loads(body or b'{}').get('duty', 50))
                S.fan = dict(S.fan or {}, duty=d)
                return self.send(200, {'ok': True, 'duty': d}, extra=self.cors())
            except Exception as e:  # noqa: BLE001
                return self.send(200, {'ok': False, 'out': str(e)}, extra=self.cors())
        if not self.same_origin():
            return self.send(403, {'ok': False, 'out': 'cross-site request refused'})
        body = self.rfile.read(int(self.headers.get('Content-Length', 0) or 0))
        if self.path.startswith('/ardzy/'):
            return self.proxy(ARDZY, self.path[len('/ardzy'):], 'POST', body or None)
        if self.path.startswith('/api/x/settings'):
            try:
                return self.send(200, dict(x_settings(json.loads(body or b'{}')), ok=True))
            except Exception as e:  # noqa: BLE001
                return self.send(200, {'ok': False, 'out': str(e)})
        if self.path.startswith('/api/x/run'):
            try:
                return self.send(200, {'ok': True, 'app': x_run(json.loads(body or b'{}').get('app', ''))})
            except Exception as e:  # noqa: BLE001
                return self.send(200, {'ok': False, 'out': str(e)})
        return self.send(404, {'ok': False, 'out': 'not found'})

    def same_origin(self):
        """Browsers send Origin on POSTs and WebSockets: it must be this board's own page."""
        o = self.headers.get('Origin')
        if not o:
            return True                                # curl and scripts on the LAN
        host = (self.headers.get('Host') or '').lower()
        return o.lower().split('://', 1)[-1] == host

    def ws_upgrade(self, fn):
        if not conf().get('shell'):                   # the X desktop gives the same power as a shell
            return self.send(403, {'ok': False, 'out': 'VIZOR shell and X desktop are off (/etc/orphan/vizor.json)'})
        key = self.headers.get('Sec-WebSocket-Key')
        if not key or self.headers.get('Upgrade', '').lower() != 'websocket' or not self.same_origin():
            return self.send(400, {'ok': False, 'out': 'not a websocket from this board'})
        acc = base64.b64encode(hashlib.sha1(key.encode() + GUID).digest()).decode()
        self.send_response(101)
        self.send_header('Upgrade', 'websocket')
        self.send_header('Connection', 'Upgrade')
        self.send_header('Sec-WebSocket-Accept', acc)
        self.end_headers()
        self.wfile.flush()
        self.close_connection = True
        fn(self)

    def ws_shell(self):
        if not conf().get('shell'):
            return self.send(403, {'ok': False, 'out': 'the VIZOR shell is off (/etc/orphan/vizor.json)'})
        key = self.headers.get('Sec-WebSocket-Key')
        if not key or self.headers.get('Upgrade', '').lower() != 'websocket' or not self.same_origin():
            return self.send(400, {'ok': False, 'out': 'not a websocket from this board'})
        acc = base64.b64encode(hashlib.sha1(key.encode() + GUID).digest()).decode()
        self.send_response(101)
        self.send_header('Upgrade', 'websocket')
        self.send_header('Connection', 'Upgrade')
        self.send_header('Sec-WebSocket-Accept', acc)
        self.end_headers()
        self.wfile.flush()
        self.close_connection = True
        q = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
        shell(self, (q.get('run') or [''])[0])


class Server(http.server.ThreadingHTTPServer):
    daemon_threads = True
    allow_reuse_address = True


S = Sampler()
if __name__ == '__main__':
    print('[orphan] VIZOR %s | by JMSCNC, makers of RotatoCAM | port %d' % (VERSION, PORT), flush=True)
    Server(('0.0.0.0', PORT), Handler).serve_forever()
