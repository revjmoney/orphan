# Orphan Games (NES): the ARM side of the FPGA NES. by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later.
#
#   Web page + WebSocket on port 8000: game list, the picture, sound, keyboard / gamepad
#   raw s16le mono sound (47.95 kHz) on TCP 8001 for ffplay
#   ORPHAN Remote (CYD): set ORPHAN_CYD=<cyd ip> (or /etc/orphan/cyd) and every picture also goes to its screen
# Games: *.nes in /opt/orphan-games/roms/nes (free homebrew only, see the README).
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
import nesrom

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
SLOT = 1
ROMS = os.environ.get('ORPHAN_ROMS', '/opt/orphan-games/roms/nes')
FB_WORDS = 12288
AUDIO_HZ = 100e6 * 10.5 / 48.875 / 448        # 47.95 kHz

try:                                           # every Orphan design assumes a 100 MHz FPGA clock
    sys.path.insert(0, '/opt/ardzy/web')
    import hwapi
    hwapi.set_fclk(0, 100)
except Exception as e:  # noqa: BLE001
    print('fclk: could not set 100 MHz:', e)

bus = Bus()
require(bus, 'NES1')
W = lambda i, v: bus.wr(SLOT, i, v)    # noqa: E731
R = lambda i: bus.rd(SLOT, i)          # noqa: E731
WBASE = (bus.m._off >> 2) + SLOT * 1024        # word index of the slot in Ardzy's mapped view
lock = threading.RLock()
state = {'game': '', 'running': False, 'fps': 0.0, 'error': '', 'cyd': ''}
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
    return sorted(os.path.basename(p) for p in glob.glob(os.path.join(ROMS, '*.nes')))


def load(name):
    path = os.path.join(ROMS, os.path.basename(name))
    try:
        cart = nesrom.parse(open(path, 'rb').read())
    except (OSError, ValueError) as e:
        state.update(error='%s: %s' % (name, e), running=False)
        return False
    with lock:
        W(0, 0)                                # console in reset
        W(2, cart['flags'])
        for base, data in ((0x00000, cart['prg']), (0x10000, cart['chr'])):
            if not data:
                continue
            W(3, base)
            done = R(3)
            for w in nesrom.words(data):
                W(512, w)
                done = (done + 1) & 0xFFFF
                t = time.time()
                while R(3) != done:            # the console side takes 4 bytes per handshake
                    if time.time() - t > 0.1:
                        state.update(error='upload stalled', running=False)
                        return False
        W(1, 0)
        W(0, 1)                                # run
    state.update(game=name, running=True, error='')
    print('loaded %s: mapper %d, PRG %d KB, CHR %d KB' % (name, cart['mapper'], cart['prg_kb'], cart['chr_kb']), flush=True)
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
            W(0, 3)                            # run + freeze at the next frame end
        t = time.time()
        while not (R(6) >> 28) & 1 and time.time() - t < 0.2:
            time.sleep(0.002)
        with lock:
            W(4, 0)
            fb = pop(512, FB_WORDS)
            W(0, 1)                            # capture again
        pic = struct.pack('<hh%dI' % FB_WORDS, 1, 0, *fb)
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
        broadcast(struct.pack('<hh', 2, 0) + pcm)
        with raw_lock:
            rs = list(raw_clients)
        for c in rs:
            try:
                c.sendall(pcm)
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
        px = np.stack([(w >> (6 * k)) & 63 for k in range(5)], axis=1).reshape(-1)[:256 * 240]
        data = RGB565[px].tobytes()
        try:
            with socket.create_connection((state['cyd'], 8091), timeout=2) as s:
                s.sendall(('POST /rect?x=32&y=0&w=256&h=240&scale=1&hud=0 HTTP/1.1\r\nHost: cyd\r\n'
                           'Content-Length: %d\r\nConnection: close\r\n\r\n' % len(data)).encode() + data)
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


def status():
    return json.dumps({'state': state, 'games': game_list(), 'audio_hz': AUDIO_HZ}).encode()


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
            W(0, 1)
    elif 'pause' in m:
        state['running'] = not m['pause']
        with lock:
            W(0, 0 if m['pause'] else 1)
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
    games = game_list()
    print('Orphan Games (NES): %d games in %s%s' % (len(games), ROMS, ', CYD ' + state['cyd'] if state['cyd'] else ''),
          flush=True)
    if games:
        load(games[0])
    for t in (frames, sound, raw_audio_server, cyd_sender):
        threading.Thread(target=t, daemon=True).start()
    ip = (subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split() or ['<board>'])[0]
    print('Orphan Games: open http://%s:%d in a browser' % (ip, PORT))
    print('Sound on your PC: ffplay -nodisp -f s16le -ar 47950 -ch_layout mono -fflags nobuffer tcp://%s:8001' % ip,
          flush=True)
    Server(('', PORT), Handler).serve_forever()
