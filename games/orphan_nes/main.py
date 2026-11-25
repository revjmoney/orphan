# Orphan Games: the ARM side of the FPGA game consoles (NES, Game Boy, Master System, Game Gear). by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later.
#
#   Web page + WebSocket on port 8000: game list, the picture, sound, keyboard / gamepad
#   raw s16le mono sound (47.95 kHz) on TCP 8001 for ffplay
#   ORPHAN Remote (CYD): set ORPHAN_CYD=<cyd ip> (or /etc/orphan/cyd) and every picture also goes to its screen
#   Real NES pads (NES design): an adapter on hashboard connectors J1 / J2 by default; ORPHAN_NES_PADS=7,8
#   (or /etc/orphan/nespads) picks other connectors, ORPHAN_NES_PADS=off turns them off. Wiring: orphan_nespad.v
# Games: /opt/orphan-games/roms/<nes|gb|sms> (free homebrew only, see the README). The loaded FPGA design says which.
import base64
import glob
import hashlib
import http.server
import json
import os
import queue
import socket
import socketserver
import struct
import subprocess
import sys
import threading
import time

import numpy as np

from blocks import Bus, require
import gbrom
import nesrom
import smsrom

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
SLOT = 1
# one profile per console design (the FPGA's ID in slot 1, word 7)
SYSTEMS = {
    'NES1': {'name': 'NES', 'dir': 'nes', 'ext': '.nes', 'w': 256, 'h': 240, 'words': 12288, 'stereo': False,
             'audio_hz': 100e6 * 10.5 / 48.875 / 448},
    'GB01': {'name': 'Game Boy', 'dir': 'gb', 'ext': '.gb', 'w': 160, 'h': 144, 'words': 1440, 'stereo': True,
             'audio_hz': 100e6 * 12 / 35.75 / 8 / 87},
    # Master System (256 x 192, 5 px of 6 bits) and Game Gear (160 x 144, 2 px of 12 bits): one design, CTRL bit 2
    'SMS1': {'name': 'Master System / Game Gear', 'dir': 'sms', 'ext': '.sms .gg', 'w': 256, 'h': 192,
             'words': 9831, 'stereo': True, 'audio_hz': 100e6 * 11.75 / 21.875 / 1119},
}

try:                                           # every Orphan design assumes a 100 MHz FPGA clock
    sys.path.insert(0, '/opt/ardzy/web')
    import hwapi
    hwapi.set_fclk(0, 100)
except Exception as e:  # noqa: BLE001
    print('fclk: could not set 100 MHz:', e)

bus = Bus()
W = lambda i, v: bus.wr(SLOT, i, v)    # noqa: E731
R = lambda i: bus.rd(SLOT, i)          # noqa: E731
SYS_ID = R(7).to_bytes(4, 'big').decode('ascii', 'replace')
if SYS_ID not in SYSTEMS:
    raise SystemExit('The FPGA holds no Orphan Games console (found %r). Load orphan_nes, orphan_gb or orphan_sms first.' % SYS_ID)
SYS = SYSTEMS[SYS_ID]
ROMS = os.environ.get('ORPHAN_ROMS', '/opt/orphan-games/roms/' + SYS['dir'])
FB_WORDS = SYS['words']
RUN = 1                                        # CTRL value while running (+4 = Game Gear mode)
SUB = {'NES1': 0, 'GB01': 1, 'SMS1': 2}[SYS_ID]  # picture type in the WebSocket frame (3 = Game Gear)
AUDIO_HZ = SYS['audio_hz']
WBASE = (bus.m._off >> 2) + SLOT * 1024        # word index of the slot in Ardzy's mapped view
lock = threading.RLock()
state = {'game': '', 'running': False, 'fps': 0.0, 'error': '', 'cyd': '', 'hwpads': ''}
pads = [0, 0]
clients, clients_lock = {}, threading.Lock()
raw_clients, raw_lock = set(), threading.Lock()


def pop(window, n):
    """n words from a pop window (each 32-bit read returns the next word)."""
    out = []
    while n > 0:
        k = min(n, 256)
        out += bus.m._w[WBASE + window:WBASE + window + k].tolist()
        n -= k
    return out


# ---------------------------------------------------------------- games
def game_list():
    return sorted(os.path.basename(p) for e in SYS['ext'].split() for p in glob.glob(os.path.join(ROMS, '*' + e)))


def load(name):
    global RUN, SUB, FB_WORDS
    path = os.path.join(ROMS, os.path.basename(name))
    try:
        if SYS_ID == 'SMS1':
            cart = smsrom.parse(open(path, 'rb').read(), name)
            reg2, parts = cart['cart'], ((0x00000, cart['rom']),)
            info = '%s, ROM %d KB' % ('Game Gear' if cart['gg'] else 'Master System', cart['kb'])
        elif SYS_ID == 'GB01':
            cart = gbrom.parse(open(path, 'rb').read())
            reg2, parts = cart['cart'], ((0x00000, cart['rom']),)
            info = 'mapper %d, ROM %d KB' % (cart['mbc'], cart['kb'])
        else:
            cart = nesrom.parse(open(path, 'rb').read())
            reg2, parts = cart['flags'], ((0x00000, cart['prg']), (0x10000, cart['chr']))
            info = 'mapper %d, PRG %d KB, CHR %d KB' % (cart['mapper'], cart['prg_kb'], cart['chr_kb'])
    except (OSError, ValueError) as e:
        state.update(error='%s: %s' % (name, e), running=False)
        return False
    with lock:
        W(0, 0)                                # console in reset
        W(2, reg2)
        for base, data in parts:
            if not data:
                continue
            W(3, base)
            done = R(3)
            for w in nesrom.words(data):     # (the same 32-bit packing for both carts)
                W(512, w)
                done = (done + 1) & 0xFFFF
                t = time.time()
                while R(3) != done:            # the console side takes 4 bytes per handshake
                    if time.time() - t > 0.1:
                        state.update(error='upload stalled', running=False)
                        return False
        if SYS_ID == 'SMS1':
            RUN, SUB = (5, 3) if cart['gg'] else (1, 2)
            FB_WORDS = 11520 if cart['gg'] else 9831
            SYS.update(w=160 if cart['gg'] else 256, h=144 if cart['gg'] else 192)
        W(1, 0)
        W(0, RUN)                              # run
    state.update(game=name, running=True, error='')
    print('loaded %s: %s' % (name, info), flush=True)
    return True


# ---------------------------------------------------------------- picture + sound
def frames():
    """Freeze the frame buffer at a frame start, read the finished picture, let it run again."""
    n, t0 = 0, time.time()
    while True:
        if not state['running']:
            time.sleep(0.1)
            continue
        # capture runs again from the next frame end; wait until it has, then ask to freeze: the frame
        # after that one is then complete and held (2 frame ends per picture: 30 pictures a second)
        t = time.time()
        while (R(6) >> 28) & 1 and time.time() - t < 0.2:
            time.sleep(0.002)
        with lock:
            W(0, RUN | 2)                      # run + freeze at the next frame end
        t = time.time()
        while not (R(6) >> 28) & 1 and time.time() - t < 0.2:
            time.sleep(0.002)
        with lock:
            W(4, 0)
            fb = pop(512, FB_WORDS)
            W(0, RUN)                          # capture again
        pic = struct.pack('<hh%dI' % len(fb), 1, SUB, *fb)
        broadcast(pic)
        cyd_frame(fb)
        n += 1
        if time.time() - t0 >= 1:
            state['fps'] = round(n / (time.time() - t0), 1)
            n, t0 = 0, time.time()


def sound():
    with lock:
        last = (R(6) >> 16) & 0x7FF
        W(5, last)
    while True:
        time.sleep(0.02)
        with lock:
            wp = (R(6) >> 16) & 0x7FF
            n = (wp - last) & 0x7FF
            if n > 1500:                       # fell behind: skip ahead
                last = (wp - 256) & 0x7FF
                W(5, last)
                n = 256
            words = pop(768, n) if n else []
        last = (last + n) & 0x7FF
        if not words:
            continue
        pcm = np.array(words, dtype='<u4').view('<i2').tobytes()
        broadcast(struct.pack('<hh', 2, 1 if SYS['stereo'] else 0) + pcm)
        with raw_lock:
            rs = list(raw_clients)
        for c in rs:
            try:
                c.sendall(pcm if not SYS['stereo'] else np.frombuffer(pcm, dtype='<i2')[0::2].tobytes())
            except OSError:
                with raw_lock:
                    raw_clients.discard(c)
                c.close()


# ---------------------------------------------------------------- ORPHAN Remote (CYD): RGB565 over TCP 8091
PAL555 = [0x39ce, 0x4464, 0x5400, 0x4c08, 0x3811, 0x0815, 0x0014, 0x002f, 0x00a8, 0x0100, 0x0140, 0x08e0,
          0x2ce3, 0x0000, 0x0000, 0x0000, 0x5ef7, 0x75c0, 0x74e4, 0x7810, 0x5c17, 0x2c1c, 0x00bb, 0x0539,
          0x01d1, 0x0240, 0x02a0, 0x1e40, 0x4600, 0x0000, 0x0000, 0x0000, 0x7fff, 0x7ee7, 0x7e4b, 0x7e28,
          0x7dfe, 0x59df, 0x31df, 0x1e7f, 0x1efe, 0x0b50, 0x2769, 0x4feb, 0x6fa0, 0x3def, 0x0000, 0x0000,
          0x7fff, 0x7f95, 0x7f58, 0x7f3a, 0x7f1f, 0x6f1f, 0x5aff, 0x577f, 0x539f, 0x53fc, 0x5fd5, 0x67f6,
          0x7bf3, 0x6318, 0x0000, 0x0000]
RGB565 = np.array([((v & 31) << 11) | ((v >> 5 & 31) << 6) | (v >> 10 & 31) for v in PAL555], dtype='<u2')
# the Game Boy's 4 greens, lightest first, as RGB565
GB565 = np.array([((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3) for r, g, b in
                  ((0xE0, 0xF0, 0xC8), (0x88, 0xC0, 0x70), (0x34, 0x68, 0x56), (0x08, 0x18, 0x20))], dtype='<u2')
# Master System (BBGGRR, 2 bits each) and Game Gear (BGR 4-4-4) colors as RGB565
SMS565 = np.array([((v & 3) * 31 // 3) << 11 | ((v >> 2 & 3) * 63 // 3) << 5 | (v >> 4 & 3) * 31 // 3
                   for v in range(64)], dtype='<u2')
GG565 = np.array([((v & 15) * 31 // 15) << 11 | ((v >> 4 & 15) * 63 // 15) << 5 | (v >> 8 & 15) * 31 // 15
                  for v in range(4096)], dtype='<u2')
cyd_q = queue.Queue(maxsize=1)


def cyd_host():
    h = os.environ.get('ORPHAN_CYD', '')
    if not h and os.path.exists('/etc/orphan/cyd'):
        h = open('/etc/orphan/cyd').read().strip()
    return h


def cyd_frame(fb):
    if not state['cyd']:
        return
    try:
        cyd_q.put_nowait(fb)
    except queue.Full:
        pass                                   # the CYD is slower than the console: keep only the newest


def cyd_sender():
    while True:
        fb = cyd_q.get()
        w = np.array(fb, dtype=np.uint32)
        if SYS_ID == 'GB01':
            px = np.stack([(w >> (2 * k)) & 3 for k in range(16)], axis=1).reshape(-1)[:160 * 144]
            data, rect = GB565[px].tobytes(), 'x=80&y=48&w=160&h=144'
        elif SUB == 3:
            px = np.stack([(w >> (12 * k)) & 4095 for k in range(2)], axis=1).reshape(-1)[:160 * 144]
            data, rect = GG565[px].tobytes(), 'x=80&y=48&w=160&h=144'
        elif SUB == 2:
            px = np.stack([(w >> (6 * k)) & 63 for k in range(5)], axis=1).reshape(-1)[:256 * 192]
            data, rect = SMS565[px].tobytes(), 'x=32&y=24&w=256&h=192'
        else:
            px = np.stack([(w >> (6 * k)) & 63 for k in range(5)], axis=1).reshape(-1)[:256 * 240]
            data, rect = RGB565[px].tobytes(), 'x=32&y=0&w=256&h=240'
        try:
            with socket.create_connection((state['cyd'], 8091), timeout=2) as s:
                s.sendall(('POST /rect?%s&scale=1&hud=0 HTTP/1.1\r\nHost: cyd\r\n'
                           'Content-Length: %d\r\nConnection: close\r\n\r\n' % (rect, len(data))).encode() + data)
                s.recv(64)
        except OSError:
            time.sleep(1)


# ---------------------------------------------------------------- web
def ws_frame(payload, opcode=2):
    n = len(payload)
    return bytes([0x80 | opcode]) + (bytes([n]) if n < 126 else bytes([126]) + struct.pack('>H', n) if n < 65536
                                     else bytes([127]) + struct.pack('>Q', n)) + payload


def broadcast(payload, opcode=2):
    f = ws_frame(payload, opcode)
    with clients_lock:
        qs = list(clients.values())
    for q in qs:
        try:
            q.put_nowait(f)
        except queue.Full:
            pass                               # a slow browser only loses its own frames


def ws_sender(sock, q):
    try:
        while True:
            f = q.get()
            if f is None:
                return
            sock.sendall(f)
    except OSError:
        pass


def ws_recv(rf):
    b = rf.read(2)
    if len(b) < 2:
        return None, None
    op, n = b[0] & 0x0F, b[1] & 0x7F
    if n == 126:
        n = struct.unpack('>H', rf.read(2))[0]
    elif n == 127:
        n = struct.unpack('>Q', rf.read(8))[0]
    mask = rf.read(4) if b[1] & 0x80 else b'\0\0\0\0'
    return op, bytes(c ^ mask[i % 4] for i, c in enumerate(rf.read(n)))


def nes_pads_setup():
    """Real NES pads on the hashboard connectors (NES design only): which connector is pad 1 and pad 2."""
    if SYS_ID != 'NES1':
        return ''
    v = os.environ.get('ORPHAN_NES_PADS', '')
    if not v and os.path.exists('/etc/orphan/nespads'):
        v = open('/etc/orphan/nespads').read().strip()
    v = (v or '1,2').lower()
    if v in ('off', '0', 'no'):
        W(9, 0)
        return 'off'
    try:
        a, b = [int(x) for x in v.replace(' ', '').split(',')[:2]]
        if not (1 <= a <= 9 and 1 <= b <= 9) or a == b:
            raise ValueError
    except ValueError:
        print('ORPHAN_NES_PADS=%r: use two different connector numbers 1..9 like 7,8 (or off); keeping J1,J2' % v)
        a, b = 1, 2
    W(9, 1 | a << 4 | b << 8)
    return 'J%d,J%d' % (a, b)


def nes_pads_state():
    if SYS_ID != 'NES1' or state.get('hwpads') in ('', 'off'):
        return None
    r, ports = R(9), R(10)
    return {'ports': [ports & 15, ports >> 4 & 15], 'present': [bool(r >> 16 & 1), bool(r >> 17 & 1)],
            'buttons': [r & 255, r >> 8 & 255]}


def pads_watch():
    """Tell the page when a real pad adapter appears or goes, or its buttons change (4 times a second)."""
    last = None
    while True:
        try:
            hp = nes_pads_state()
        except Exception:  # noqa: BLE001
            hp = None
        if hp != last:
            last = hp
            broadcast(json.dumps({'hwpads': hp, 'hwports': state.get('hwpads', '')}).encode(), opcode=1)
        time.sleep(0.25)


def status():
    return json.dumps({'state': state, 'hwpads': nes_pads_state(), 'hwports': state.get('hwpads', ''), 'games': game_list(), 'audio_hz': AUDIO_HZ, 'system': SYS['name'],
                       'w': SYS['w'], 'h': SYS['h'], 'ext': SYS['ext'], 'roms': ROMS}).encode()


def handle(m):
    if 'pads' in m:
        pads[0], pads[1] = int(m['pads'][0]) & 0xFF, int(m['pads'][1]) & 0xFF if len(m['pads']) > 1 else 0
        with lock:
            W(1, pads[0] | pads[1] << 8)
    elif 'load' in m:
        load(m['load'])
        broadcast(status(), opcode=1)
    elif 'reset' in m:
        with lock:
            W(0, 0)
            time.sleep(0.05)
            W(0, RUN)
    elif 'pause' in m:
        state['running'] = not m['pause']
        with lock:
            W(0, 0 if m['pause'] else RUN)
        broadcast(status(), opcode=1)


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def do_GET(self):
        if self.path.startswith('/ws') and self.headers.get('Upgrade', '').lower() == 'websocket':
            acc = base64.b64encode(hashlib.sha1((self.headers['Sec-WebSocket-Key'] +
                                                 '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').encode()).digest())
            self.send_response(101)
            self.send_header('Upgrade', 'websocket')
            self.send_header('Connection', 'Upgrade')
            self.send_header('Sec-WebSocket-Accept', acc.decode())
            self.end_headers()
            self.wfile.flush()
            sock, q = self.connection, queue.Queue(maxsize=8)
            with clients_lock:
                clients[sock] = q
            threading.Thread(target=ws_sender, args=(sock, q), daemon=True).start()
            q.put(ws_frame(status(), 1))
            try:
                while True:
                    op, data = ws_recv(self.rfile)
                    if op is None or op == 8:
                        break
                    if op == 1:
                        try:
                            handle(json.loads(data))
                        except (ValueError, KeyError, TypeError) as e:
                            print('bad message:', e, flush=True)
            except OSError:
                pass
            finally:
                with clients_lock:
                    clients.pop(sock, None)
                q.put(None)
            return
        if self.path == '/adapter.svg':                     # the NES pad adapter diagram
            body = open(os.path.join(HERE, 'adapter.svg'), 'rb').read()
            self.send_response(200)
            self.send_header('Content-Type', 'image/svg+xml')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        if self.path not in ('/', '/index.html'):
            self.send_error(404)
            return
        body = open(os.path.join(HERE, 'index.html'), 'rb').read()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)


class Server(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


def raw_audio_server():
    srv = socket.socket()
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    srv.bind(('', 8001))
    srv.listen(4)
    while True:
        c, _ = srv.accept()
        c.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        with raw_lock:
            raw_clients.add(c)


if __name__ == '__main__':
    state['cyd'] = cyd_host()
    state['hwpads'] = nes_pads_setup()
    if state['hwpads'] not in ('', 'off'):
        time.sleep(0.01)
        hp = nes_pads_state()
        print('Real NES pads on %s: %s' % (state['hwpads'], ', '.join(
            'pad %d %s' % (i + 1, 'adapter found' if hp['present'][i] else 'no adapter') for i in range(2))), flush=True)
    games = game_list()
    print('Orphan Games (%s): %d games in %s%s' % (SYS['name'], len(games), ROMS, ', CYD ' + state['cyd'] if state['cyd'] else ''),
          flush=True)
    if games:
        load(games[0])
    for t in (frames, sound, raw_audio_server, cyd_sender, pads_watch):
        threading.Thread(target=t, daemon=True).start()
    ip = (subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split() or ['<board>'])[0]
    print('Orphan Games: open http://%s:%d in a browser' % (ip, PORT))
    print('Sound on your PC: ffplay -nodisp -f s16le -ar %d -ch_layout mono -fflags nobuffer tcp://%s:8001' % (round(AUDIO_HZ), ip),
          flush=True)
    Server(('', PORT), Handler).serve_forever()
