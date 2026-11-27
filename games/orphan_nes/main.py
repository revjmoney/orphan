# Orphan Games: the ARM side of the FPGA game consoles (NES, Game Boy, Master System, Game Gear, Atari 2600). by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later.
#
#   Web page + WebSocket on port 8000: game list, the picture, sound, keyboard / gamepad
#   raw s16le mono sound (47.95 kHz) on TCP 8001 for ffplay
#   ORPHAN Remote (CYD): set ORPHAN_CYD=<cyd ip> (or /etc/orphan/cyd) and every picture also goes to its screen
#   Real NES pads (NES and Game Boy designs): an adapter on hashboard connectors J1 / J2 by default; ORPHAN_NES_PADS=7,8
#   (or /etc/orphan/nespads) picks other connectors, ORPHAN_NES_PADS=off turns them off. Wiring: orphan_nespad.v
#   DISCONNECT EVERY HASHBOARD before using real pads. ORPHAN_NES_PADS_NEVER=6,7 (or /etc/orphan/nespads-never) is an
#   optional extra: connectors that are never driven or read (default: none)
# Games: /opt/orphan-games/roms/<nes|gb|sms|a26> (free homebrew only, see the README). The loaded FPGA design says which.
import array
import multiprocessing
import atexit
import base64
import glob
import hashlib
import http.server
import json
import os
import queue
import signal
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
import cydlink
from cydlink import RGB565, GB565, SMS565, GG565
import a26pal
import a26rom
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
    # Atari 2600: 160 x 240 lines kept from YSTART (register 14), 4 pixels of 8 bits (TIA colour 0..127) per word,
    # the last two frames (2 x 9600 words), merged into one picture by a26_merge()
    'A261': {'name': 'Atari 2600', 'dir': 'a26', 'ext': '.bin .a26', 'w': 160, 'h': 240, 'words': 19200,
             'stereo': True, 'audio_hz': 100e6 * 9.875 / 34.5 / 8 / 74},
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
    raise SystemExit('The FPGA holds no Orphan Games console (found %r). Load orphan_nes, orphan_gb, orphan_sms or orphan_a26 first.' % SYS_ID)
SYS = SYSTEMS[SYS_ID]
ROMS = os.environ.get('ORPHAN_ROMS', '/opt/orphan-games/roms/' + SYS['dir'])
FB_WORDS = SYS['words']
RUN = 1                                        # CTRL value while running (+4 = Game Gear mode)
HW_PAD_DESIGNS = ('NES1', 'GB01', 'A261')               # designs with orphan_nespad (real NES pads on J1..J9)
SUB = {'NES1': 0, 'GB01': 1, 'SMS1': 2, 'A261': 4}[SYS_ID]  # picture type in the WebSocket frame (3 = Game Gear)
AUDIO_HZ = SYS['audio_hz']
WBASE = (bus.m._off >> 2) + SLOT * 1024        # word index of the slot in Ardzy's mapped view
lock = threading.RLock()
state = {'game': '', 'running': False, 'fps': 0.0, 'error': '', 'cyd': '', 'hwpads': '', 'hwnever': []}
pads = [0, 0]
clients, clients_lock = {}, threading.Lock()
raw_clients, raw_lock = set(), threading.Lock()


def pop(window, n):
    """n words from a pop window (each 32-bit read returns the next word)."""
    out = array.array('I')                     # one 32-bit read per word, straight into a compact array
    while n > 0:
        k = min(n, 256)
        out.extend(bus.m._w[WBASE + window:WBASE + window + k])
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
        elif SYS_ID == 'A261':
            cart = a26rom.parse(open(path, 'rb').read(), name)
            reg2, parts = cart['cart'], ((0x00000, cart['rom']),)
            info = '%s, ROM %d KB' % (cart['scheme'], cart['kb'])
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
        if SYS_ID == 'A261':
            W(13, 0)                           # colour TV, both difficulty switches on B (the usual setting)
        W(1, 0)
        W(0, RUN)                              # run
    state.update(game=name, running=True, error='')
    print('loaded %s: %s' % (name, info), flush=True)
    return True


# ---------------------------------------------------------------- picture + sound
def a26_merge(fb):
    """Atari 2600: many games flicker (half their objects on each frame). The core keeps the last two frames;
    show both at once, the brighter pixel of the two wins (like an emulator's phosphor mode)."""
    a = np.frombuffer(fb, dtype=np.uint8)
    f0, f1 = a[:38400], a[38400:76800]
    return array.array('I', np.where((f1 & 7) > (f0 & 7), f1, f0).tobytes())


def double_buffer():
    """True when the loaded core is the NES with two frame buffers (register 12 answers a hold)."""
    if SYS_ID != 'NES1':                       # (on the other cores CTRL bit 2 means something else)
        return False
    with lock:
        W(0, RUN | 4)
        ok = any((R(12) >> 16) & 1 for _ in range(50))
        W(0, RUN)
    return ok


def frames():
    """Read every finished picture. NES with two frame buffers: hold the front buffer, read it, release (60 a
    second). Older cores: freeze the frame buffer at a frame start, read it, let it run again (30 a second)."""
    n, t0, dbl, last, nb = 0, time.time(), None, -1, 0
    while True:
        if not state['running']:
            time.sleep(0.1)
            dbl = None
            continue
        if dbl is None:
            dbl = double_buffer()
            print('frame buffer: %s' % ('double (every frame)' if dbl else 'freeze handshake (every other frame)'),
                  flush=True)
        if dbl:
            t = time.time()
            while (R(12) & 0xFFFF) == last and time.time() - t < 0.2:
                time.sleep(0.001)
            tp = time.perf_counter()
            with lock:
                W(0, RUN | 4)                      # hold: the newest whole picture stays put while we read it
                for _ in range(50):
                    st = R(12)
                    if (st >> 16) & 1:
                        break
                last = st & 0xFFFF
                W(4, 0)
                fb = pop(512, FB_WORDS)
                W(0, RUN)
        else:
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
            tp = time.perf_counter()
            with lock:
                W(4, 0)
                fb = pop(512, FB_WORDS)
                W(0, RUN)                          # capture again
        if SYS_ID == 'A261':
            fb = a26_merge(fb)
        state['pop_ms'] = state.get('pop_ms', 0.0) * 0.9 + (time.perf_counter() - tp) * 100
        nb += 1
        if not dbl or nb & 1:                  # the browser stream stays at 30 a second (board CPU)
            broadcast(struct.pack('<hh', 1, SUB) + fb.tobytes())
        cyd_frame(fb)
        n += 1
        if time.time() - t0 >= 1:
            state['fps'] = round(n / (time.time() - t0), 1)
            n, t0 = 0, time.time()
            logn = state.get('_logn', 0) + 1
            state['_logn'] = logn
            cpu = time.thread_time()
            state['frames_cpu'] = round((cpu - state.get('_fcpu', cpu)) * 100, 1)   # % of one core, this thread
            state['_fcpu'] = cpu
            if logn % 10 == 0:
                print('pictures/s: console %.1f, CYD %.1f (%.1f ms per CYD picture); read %.1f ms, cpu: frames %s%%, CYD %s%%, '
                      '%d bytes per CYD picture' % (state['fps'], cyd_stats[0], cyd_stats[1], state.get('pop_ms', 0.0),
                                                   state.get('frames_cpu', 0), round(cyd_stats[3], 1), cyd_stats[2]),
                      flush=True)


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
        pcm = np.frombuffer(words, dtype='<u4').view('<i2').tobytes()
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


def cyd_host():
    h = os.environ.get('ORPHAN_CYD', '')
    if not h and os.path.exists('/etc/orphan/cyd'):
        h = open('/etc/orphan/cyd').read().strip()
    return h


# The CYD sender runs in its own process (the board's second core): Python runs one thread at a time, and the
# frame buffer reads, the browser feed and the CYD encoder no longer fit one core at full speed.
# Two picture slots in shared memory: the board writes the newest picture into the slot the sender is not reading,
# the sender always takes the newest one as soon as it is free (a picture it was too slow for is skipped).
CYD_SLOT = 4 * 12288
cyd_ctx = multiprocessing.get_context('fork')  # (the child shares this module's state as it is now)
cyd_slots = cyd_ctx.RawArray('B', 2 * CYD_SLOT)
cyd_meta = cyd_ctx.RawArray('i', 4)            # [picture number, SUB of slot 0, SUB of slot 1, words]
cyd_new = cyd_ctx.Event()
cyd_stats = cyd_ctx.RawArray('d', 4)           # pictures/s, ms per picture, bytes, cpu %
cyd_on = False


def cyd_frame(fb):
    if not cyd_on:
        return
    k = (cyd_meta[0] + 1) & 0x7FFFFFFF
    b = fb.tobytes()
    memoryview(cyd_slots).cast('B')[(k & 1) * CYD_SLOT:(k & 1) * CYD_SLOT + len(b)] = b
    cyd_meta[1 + (k & 1)], cyd_meta[3] = SUB, len(b)
    cyd_meta[0] = k
    cyd_new.set()


def cyd_take(last):
    """Wait for a picture newer than `last`, copy it out: (number, SUB, bytes)."""
    while cyd_meta[0] == last:
        cyd_new.wait(1)
        cyd_new.clear()
    k = cyd_meta[0]
    off = (k & 1) * CYD_SLOT
    return k, cyd_meta[1 + (k & 1)], bytes(memoryview(cyd_slots).cast('B')[off:off + cyd_meta[3]])


def cyd_process_start():
    global cyd_on
    if state['cyd']:
        cyd_ctx.Process(target=cyd_sender, daemon=True).start()
        cyd_on = True


A26565 = np.array([((v >> 19) << 11) | ((v >> 10 & 63) << 5) | (v >> 3 & 31) for v in a26pal.NTSC], dtype='<u2')
SH_GB = np.arange(0, 32, 2, dtype=np.uint32)        # bit offsets of the pixels inside one frame buffer word
SH_GG = np.array([0, 12], dtype=np.uint32)
SH_6 = np.arange(0, 30, 6, dtype=np.uint32)


def cyd_layout(fb):
    """The picture as the CYD game stream wants it: (image, scale, x, y, palette). Game Boy and Game Gear are
    shown 1.5x (240 x 216, in-between pixels blended), NES and Master System 1:1."""
    if SYS_ID == 'A261':                       # 160 x 240 (the CYD stream takes rows up to 256 wide): 1:1, centred
        return np.frombuffer(fb, dtype=np.uint8)[:160 * 240].reshape(240, 160), 0, 80, 0, A26565
    w = np.frombuffer(fb, dtype=np.uint32)[:, None]
    if SYS_ID == 'GB01':
        px = ((w >> SH_GB) & 3).astype(np.uint8).reshape(-1)[:160 * 144]
        return px.reshape(144, 160), 1, 40, 12, GB565
    if SUB == 3:
        px = ((w >> SH_GG) & 4095).reshape(-1)[:160 * 144]
        return GG565[px].reshape(144, 160), 1, 40, 12, None
    px = cydlink.unpack6(fb, 256 * 240)
    if SUB == 2:
        return px[:256 * 192].reshape(192, 256), 0, 32, 24, SMS565
    return px[:256 * 240].reshape(240, 256), 0, 32, 0, RGB565


def cyd_stream_kind(host):
    """What the ORPHAN Remote offers (from its /status): 'udp' (game stream on UDP 8093, fastest), 'tcp' (TCP 8092)
    or 'rect' (older firmware: one RGB565 rectangle per picture on 8091)."""
    try:
        with socket.create_connection((host, 80), timeout=2) as s:
            s.sendall(b'GET /status HTTP/1.1\r\nHost: cyd\r\nConnection: close\r\n\r\n')
            data = b''
            while True:
                chunk = s.recv(2048)
                if not chunk:
                    break
                data += chunk
    except OSError:
        return 'rect'
    if b'"game_udp":8093' in data:
        return 'udp'
    if b'"game_port":8092' in data:
        return 'tcp'
    return 'rect'


def cyd_sender_rect(fb):
    """Older ORPHAN Remote firmware: one RGB565 rectangle per picture over HTTP on 8091."""
    img, scale, x, y, pal = cyd_layout(fb)
    if scale:                                  # no 1.5x on old firmware: centre the picture 1:1
        x, y = (320 - img.shape[1]) // 2, (240 - img.shape[0]) // 2
    data = (img if pal is None else pal[img]).astype('<u2').tobytes()
    rect = 'x=%d&y=%d&w=%d&h=%d' % (x, y, img.shape[1], img.shape[0])
    with socket.create_connection((state['cyd'], 8091), timeout=2) as s:
        s.sendall(('POST /rect?%s&scale=1&hud=0 HTTP/1.1\r\nHost: cyd\r\n'
                   'Content-Length: %d\r\nConnection: close\r\n\r\n' % (rect, len(data))).encode() + data)
        s.recv(64)


def cyd_sender():
    global SUB
    link, kind, checked, last = None, 'rect', 0.0, 0
    n, t0, cpu0 = 0, time.time(), time.process_time()
    while True:
        last, SUB, fb = cyd_take(last)
        try:
            if kind == 'rect' and time.time() - checked > 30:
                kind, checked = cyd_stream_kind(state['cyd']), time.time()
                link = (cydlink.CydLinkUdp(state['cyd']) if kind == 'udp' else
                        cydlink.CydLink(state['cyd']) if kind == 'tcp' else None)
                print('CYD %s: %s stream' % (state['cyd'], kind), flush=True)
            if link:
                ts = time.perf_counter()
                img, scale, x, y, pal = cyd_layout(fb)
                nb = link.send(img, scale=scale, x=x, y=y, palette=pal)
                cyd_stats[2] = cyd_stats[2] * 0.9 + (nb or 0) * 0.1
                cyd_stats[1] = cyd_stats[1] * 0.9 + (time.perf_counter() - ts) * 100
            else:
                cyd_sender_rect(fb)
            n += 1
            if time.time() - t0 >= 1:
                cyd_stats[0] = n / (time.time() - t0)
                cyd_stats[3] = (time.process_time() - cpu0) * 100 / (time.time() - t0)
                n, t0, cpu0 = 0, time.time(), time.process_time()
        except cydlink.CydBusy:                # a video is on the CYD: wait for it to finish, try again
            time.sleep(1)
        except OSError:
            kind, checked, link = 'rect', 0.0, None
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
    """Real NES pads on the hashboard connectors (NES and Game Boy designs): which connector is pad 1 and pad 2."""
    if SYS_ID not in HW_PAD_DESIGNS or R(10) == 0:   # register 10 reads 0 on a design without the pad reader
        return ''
    v = os.environ.get('ORPHAN_NES_PADS', '')
    if not v and os.path.exists('/etc/orphan/nespads'):
        v = open('/etc/orphan/nespads').read().strip()
    v = (v or '1,2').lower()
    W(9, 0)                                  # off first: never move the pins while a pad is being driven
    time.sleep(0.005)                        # (one scan is 1 ms)
    # optional: connectors that are never driven or read: ORPHAN_NES_PADS_NEVER or /etc/orphan/nespads-never
    # (default none: every connector is available; disconnect every hashboard before using real pads)
    nv = os.environ.get('ORPHAN_NES_PADS_NEVER', '')
    if not nv and os.path.exists('/etc/orphan/nespads-never'):
        nv = open('/etc/orphan/nespads-never').read().strip()
    nv = (nv or 'none').lower()
    never = set()
    if nv not in ('none', 'off', '0'):
        never = {int(x) for x in nv.replace(' ', '').split(',') if x.isdigit() and 1 <= int(x) <= 9}
        if not never:
            print('ORPHAN_NES_PADS_NEVER=%r: not understood (use connector numbers like 6,7)' % nv)
    W(11, sum(1 << (n - 1) for n in never))
    state['hwnever'] = sorted(never)
    if v in ('off', '0', 'no'):
        return 'off'
    try:
        a, b = [int(x) for x in v.replace(' ', '').split(',')[:2]]
        if not (1 <= a <= 9 and 1 <= b <= 9) or a == b:
            raise ValueError
    except ValueError:
        print('ORPHAN_NES_PADS=%r: use two different connector numbers 1..9 like 7,8 (or off); keeping J1,J2' % v)
        a, b = 1, 2
    if a in never or b in never:
        print('Real NES pads stay OFF: J%s is in ORPHAN_NES_PADS_NEVER=%s. Pick other connectors, or change that list.'
              % (a if a in never else b, nv), flush=True)
        return 'off'
    W(9, 1 | a << 4 | b << 8)
    atexit.register(lambda: W(9, 0))         # stop reading (and driving) the headers when this program ends
    return 'J%d,J%d' % (a, b)


def nes_pads_state():
    if SYS_ID not in HW_PAD_DESIGNS or state.get('hwpads') in ('', 'off'):
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
            broadcast(json.dumps({'hwpads': hp, 'hwports': state.get('hwpads', ''),
                                  'hwnever': state.get('hwnever', [])}).encode(), opcode=1)
        time.sleep(0.25)


def status():
    return json.dumps({'state': state, 'hwpads': nes_pads_state(), 'hwports': state.get('hwpads', ''),
                       'hwnever': state.get('hwnever', []), 'games': game_list(), 'audio_hz': AUDIO_HZ, 'system': SYS['name'], 'hwpad_design': SYS_ID in HW_PAD_DESIGNS,
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
            try:
                body = open(os.path.join(HERE, 'adapter.svg'), 'rb').read()
            except OSError:
                self.send_error(404)
                return
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
    signal.signal(signal.SIGTERM, lambda *a: sys.exit(0))   # so atexit runs when systemd or ardzy stops it
    state['hwpads'] = nes_pads_setup()
    if state['hwpads'] not in ('', 'off'):
        time.sleep(0.01)
        hp = nes_pads_state()
        print('!! Real NES pads on %s: disconnect every hashboard from this board !!' % state['hwpads'], flush=True)
        print('Real NES pads on %s: %s' % (state['hwpads'], ', '.join(
            'pad %d %s' % (i + 1, 'adapter found' if hp['present'][i] else 'no adapter') for i in range(2))), flush=True)
    games = game_list()
    print('Orphan Games (%s): %d games in %s%s' % (SYS['name'], len(games), ROMS, ', CYD ' + state['cyd'] if state['cyd'] else ''),
          flush=True)
    if games:
        load(games[0])
    cyd_process_start()                        # before any thread starts (it forks)
    for t in (frames, sound, raw_audio_server, pads_watch):
        threading.Thread(target=t, daemon=True).start()
    ip = (subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split() or ['<board>'])[0]
    print('Orphan Games: open http://%s:%d in a browser' % (ip, PORT))
    print('Sound on your PC: ffplay -nodisp -f s16le -ar %d -ch_layout mono -fflags nobuffer tcp://%s:8001' % (round(AUDIO_HZ), ip),
          flush=True)
    Server(('', PORT), Handler).serve_forever()
