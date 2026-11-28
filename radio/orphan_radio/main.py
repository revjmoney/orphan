# Orphan Radio: the ARM side of the FPGA AM receiver (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
#
#   Web GUI + WebSocket on port 8000: tuning, band scan, S-meter, scope + spectrum, audio to the browser
#   raw s16le mono audio (12207 Hz) on TCP 8001 for ffplay
#   AGC (audio gain from the carrier level) and auto RF gain (baseband shift) run here
import base64
import hashlib
import http.server
import json
import queue
import math
import os
import socketserver
import struct
import subprocess
import sys
import threading
import time

from blocks import Bus, require
import cydradio

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
FCLK = 100e6
FS = FCLK / 8192                      # 12207.03 Hz complex baseband / audio
SLOT = 1

# every Orphan design assumes a 100 MHz FPGA clock; the Bitmain bootloader leaves FCLK0 at 50 MHz
try:
    sys.path.insert(0, '/opt/ardzy/web')
    import hwapi
    hwapi.set_fclk(0, 100)
except Exception as e:  # noqa: BLE001
    print('fclk: could not set 100 MHz:', e)

bus = Bus()
require(bus, 'RAD1')
W = lambda i, v: bus.wr(SLOT, i, v)    # noqa: E731
R = lambda i: bus.rd(SLOT, i)          # noqa: E731
WIN = (SLOT * 0x1000 + 512 * 4) // 4   # word index of the capture pop window in the bus mapping
lock = threading.RLock()

MODES = {'antenna': 2, 'loopback': 1, 'jumper': 0, 'rc': 3}
state = {
    'freq': 1000.0,          # kHz
    'mode': 'antenna',       # antenna (zero parts) / loopback (internal) / jumper (wire pin 5 -> pin 12) / rc
    'agc': 1, 'auto_rf': 1, 'rf': 0, 'af': 2048,
    'tx': 0, 'tx_freq': 1000.0, 'tone': 625.0, 'depth': 0.8, 'melody': 0,
    'sd_pulse': 1, 'dither': 1, 'demod': 'am', 'auto_mode': 1,
    # filters: noise blanker (FPGA), hum comb (FPGA for AM, browser for the other modes), auto-notch (browser)
    'nb': 0, 'nb_len': 6, 'hum': 0, 'hum_fine': 0.0, 'hum_depth': 0.7, 'anf': 0,
    'decoder': 'off', 'board_dsp': 0,
    # slices B..D (tuners 2..4 in the FPGA) and the wide panadapter; 'multi' = this FPGA build has them
    'multi': 0,
    'slices': [{'freq': 7074.0, 'demod': 'usb', 'on': 0}, {'freq': 14230.0, 'demod': 'usb', 'on': 0},
               {'freq': 10000.0, 'demod': 'am', 'on': 0}],
    'pan': {'on': 1, 'center': 1000.0, 'rlog': 6, 'gain': 8},
}
meter = {'carrier': 0, 'density': 0, 'rf': 0, 'af': 0}
scan_result = {'start': 0, 'step': 0, 'levels': []}


def step(hz):
    return int(round(hz * (1 << 32) / FCLK)) & 0xFFFFFFFF


def ctrl_word():
    return 1 | (MODES[state['mode']] << 1) | (8 if state['tx'] else 0) | 16 | (32 if state['dither'] else 0)


def apply_all():
    with lock:
        W(0, ctrl_word())
        W(1, step(state['freq'] * 1000))
        W(2, int(state['rf']))
        W(3, int(state['af']))
        W(4, step(state['tx_freq'] * 1000))
        W(5, step(state['tone']))
        W(6, int(max(0, min(1, state['depth'])) * 255))
        W(7, int(state['sd_pulse']))
        W(13, (int(state['nb']) & 31) | (int(state['nb_len']) & 15) << 8)
        line = float(state['hum']) + float(state['hum_fine'])
        dly = int(round(FS / line * 256)) if state['hum'] else 52083
        W(14, (1 if state['hum'] else 0) | (min(0xFFFF, dly) << 8))
        W(15, int((0.85 + 0.14 * max(0.0, min(1.0, float(state['hum_depth'])))) * 32768))
        # cubic (4-point Lagrange) weights for the fractional part of the comb delay, Q14
        t = (dly & 0xFF) / 256.0
        for i, cf in enumerate((-t * (t - 1) * (t - 2) / 6, (t + 1) * (t - 1) * (t - 2) / 2,
                                -(t + 1) * t * (t - 2) / 2, (t + 1) * t * (t - 1) / 6)):
            W(17 + i, int(round(cf * 16384)) & 0xFFFF)
        if state['multi']:
            for i, s in enumerate(state['slices']):
                W(21 + i, step(float(s['freq']) * 1000))
            W(24, step(float(state['pan']['center']) * 1000))


def set_slice(m):
    """{i: 1..3, freq, demod, on} for slices B..D."""
    i = int(m.get('i', 0)) - 1
    if not 0 <= i < 3:
        return
    s = state['slices'][i]
    if 'freq' in m:
        s['freq'] = max(1.0, min(49000.0, round(float(m['freq']), 3)))
    if m.get('demod') in DEMODS:
        s['demod'] = m['demod']
    if 'on' in m:
        s['on'] = 1 if m['on'] else 0
    apply_all()
    rx_push()


def set_pan(m):
    p = state['pan']
    if 'center' in m:
        p['center'] = max(0.0, min(50000.0, round(float(m['center']), 3)))
    if 'rlog' in m:
        p['rlog'] = max(4, min(8, int(m['rlog'])))
    if 'gain' in m:
        p['gain'] = max(0, min(15, int(m['gain'])))
    if 'on' in m:
        p['on'] = 1 if m['on'] else 0
    apply_all()
    rx_push()


def set_param(k, v):
    if k not in state:
        return
    if k == 'mode' and v not in MODES:
        return
    if k == 'demod' and v not in DEMODS:
        return
    if k == 'decoder' and v not in DECODERS:
        return
    state[k] = v if k in ('mode', 'demod', 'decoder') else float(v)
    if k == 'freq' and state['auto_mode']:
        bm = band_at(state['freq'])['mode']
        if bm:
            state['demod'] = bm
    if k == 'freq':
        state['freq'] = max(1.0, min(49000.0, state['freq']))
    apply_all()
    rx_push()


# ---------------------------------------------------------------- AGC + auto RF gain
def control_loop():
    while True:
        time.sleep(0.05)
        with lock:
            c = R(8)
            d = R(11)
            if state['auto_rf']:
                rf = int(state['rf'])
                if c > 16000 and rf > 0:
                    state['rf'] = rf - 1
                elif c < 2500 and rf < 15:
                    state['rf'] = rf + 1
                W(2, int(state['rf']))
            if state['agc']:
                state['af'] = max(64, min(65535, int(16000 * 1024 / max(c, 200))))
                W(3, int(state['af']))
            nbc = R(16)
        meter.update(carrier=c, density=d, rf=int(state['rf']), af=int(state['af']), blanked=nbc)


# ---------------------------------------------------------------- melody for the test transmitter
MELODY = [(659, .2), (622, .2), (659, .2), (622, .2), (659, .2), (494, .2), (587, .2), (523, .2), (440, .6),
          (262, .2), (330, .2), (440, .2), (494, .6), (330, .2), (415, .2), (494, .2), (523, .6)]


def melody_loop():
    i = 0
    while True:
        if state['melody'] and state['tx'] or (state['melody'] and state['mode'] == 'loopback'):
            hz, dur = MELODY[i % len(MELODY)]
            with lock:
                W(5, step(hz))
            time.sleep(dur)
            i += 1
        else:
            time.sleep(0.1)


# ---------------------------------------------------------------- capture: block reads from the pop window
def read_words():
    with lock:
        n = R(9) & ~1
        n = min(n, 512)
        if n <= 0:
            return []
        return bus.m._w[(bus.m._off >> 2) + WIN:(bus.m._off >> 2) + WIN + n].tolist()


def to16(x):
    return x - 65536 if x & 0x8000 else x


# ---------------------------------------------------------------- orphan-rxd: demods, filters and decoders on the board
# rxd owns the FPGA stream and writes {I, Q, audio} into a ring in /dev/shm/orphan_rx; this program only streams it.
RXD_SRC = os.path.join(HERE, 'rxd.c')
RXD_BIN = os.path.join(HERE, 'orphan-rxd')
RX_SHM = '/dev/shm/orphan_rx'
RX_HEAD = '<IiiffiiiIiIiffiI'                   # magic .. text_w (16 x 4 bytes); then status[128], text[8192], ring
RX_TEXTN, RX_RING, RX_RING_OFF = 8192, 65536, 64 + 128 + 8192
DECODERS = ['off', 'cw', 'navtex', 'wwvb', 'sstv']
RX_IMG_OFF = RX_RING_OFF + RX_RING * 6           # SSTV picture: img_seq, img_w, img_h, img_rows, img_mode[16], img
RX_IMG_W, RX_IMG_H = 640, 496
RX_MULTI_OFF = RX_IMG_OFF + 32 + RX_IMG_W * RX_IMG_H * 3
# multi, s_demod[3], s_wpos, s_level[3], pan_on, pan_rlog, pan_gain, pan_seq, pan_freq, pan_rlog_used
RX_MULTI_HEAD = '<i3iI3f3iIIi'
RX_PAN_N, RX_SRING = 2048, 16384
RX_PAN_OFF = RX_MULTI_OFF + struct.calcsize(RX_MULTI_HEAD)
RX_SRING_OFF = RX_PAN_OFF + RX_PAN_N * 4
RX_SIZE = RX_SRING_OFF + RX_SRING * 18
SSTV_DIR = os.path.join(HERE, 'sstv')
rx = {'proc': None, 'mm': None, 'ring': None}


def png_bytes(w, h, rgb):
    """Minimal PNG encoder (RGB, no filter), so the board needs no imaging library."""
    import zlib
    raw = b''.join(b'\x00' + rgb[y * w * 3:(y + 1) * w * 3] for y in range(h))

    def chunk(t, d):
        return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xFFFFFFFF)
    return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0)) +
            chunk(b'IDAT', zlib.compress(raw, 6)) + chunk(b'IEND', b''))


def sstv_head():
    seq, w, h, rows = struct.unpack_from('<Iiii', rx['mm'], RX_IMG_OFF)
    mode = bytes(rx['mm'][RX_IMG_OFF + 16:RX_IMG_OFF + 32]).split(b'\0')[0].decode('ascii', 'replace')
    return seq, w, h, rows, mode


def sstv_rows(w, a, b):
    """RGB bytes of picture rows [a, b) (rows are IMG_W wide in the shm; crop to the mode's width)."""
    out = bytearray()
    for r in range(a, b):
        o = RX_IMG_OFF + 32 + r * RX_IMG_W * 3
        out += rx['mm'][o:o + w * 3]
    return bytes(out)


def sstv_save(w, h, rows, mode):
    if rows < h // 3:
        return None
    os.makedirs(SSTV_DIR, exist_ok=True)
    data = png_bytes(w, rows, sstv_rows(w, 0, rows))
    name = time.strftime('%Y%m%d-%H%M%S') + '-' + mode.replace(' ', '') + '.png'
    for f in (name, 'latest.png'):
        with open(os.path.join(SSTV_DIR, f), 'wb') as fh:
            fh.write(data)
    print('sstv: saved', name, flush=True)
    return name


def rx_start():
    import mmap
    import numpy as np
    try:
        if not os.path.exists(RXD_BIN) or os.path.getmtime(RXD_BIN) < os.path.getmtime(RXD_SRC):
            subprocess.run(['gcc', '-O2', '-o', RXD_BIN, RXD_SRC, '-lm'], check=True)
        size = RX_SIZE
        fd = os.open(RX_SHM, os.O_RDWR | os.O_CREAT, 0o600)
        os.ftruncate(fd, size)
        rx['mm'] = mmap.mmap(fd, size)
        os.close(fd)
        rx['proc'] = subprocess.Popen([RXD_BIN])
        time.sleep(0.5)
        if rx['proc'].poll() is not None:
            raise RuntimeError('orphan-rxd exited')
        rx['ring'] = np.frombuffer(rx['mm'], dtype=np.int16, count=RX_RING * 3, offset=RX_RING_OFF).reshape(RX_RING, 3)
        rx['sring'] = np.frombuffer(rx['mm'], dtype=np.int16, count=RX_SRING * 9,
                                    offset=RX_SRING_OFF).reshape(RX_SRING, 3, 3)
        rx_push()
        return True
    except Exception as e:  # noqa: BLE001
        print('rxd: board DSP not available, the browser demodulates instead:', e, flush=True)
        rx['proc'] = None
        return False


def rx_ok():
    return rx['proc'] is not None and rx['proc'].poll() is None


def rx_head():
    return list(struct.unpack_from(RX_HEAD, rx['mm'], 0))


def rx_push(cmd=None):
    if not rx['mm']:
        return
    h = rx_head()
    h[0] = 0x3158524F
    h[1] = DEMODS.index(state['demod']) if state['demod'] in DEMODS else 0
    h[2] = int(state['hum'])
    h[3] = float(state['hum_fine'])
    h[4] = float(state['hum_depth'])
    h[5] = int(state['anf'])
    h[6] = DECODERS.index(state['decoder']) if state['decoder'] in DECODERS else 0
    if cmd:
        h[9] = cmd
        h[8] = (h[8] + 1) & 0xFFFFFFFF
    struct.pack_into('<IiiffiiiIi', rx['mm'], 0, *h[:10])
    sd = [DEMODS.index(s['demod']) if s['on'] and s['demod'] in DEMODS else -1 for s in state['slices']]
    struct.pack_into('<3i', rx['mm'], RX_MULTI_OFF + 4, *sd)
    p = state['pan']
    struct.pack_into('<3i', rx['mm'], RX_MULTI_OFF + 32, int(p['on']), int(p['rlog']), int(p['gain']))


def rx_text(since):
    """New decoder text after character count `since` -> (text, new count)."""
    h = rx_head()
    tw = h[15]
    if tw < since:
        since = 0
    if tw - since > RX_TEXTN:
        since = tw - RX_TEXTN
    out = bytearray()
    base = 192
    for i in range(since, tw):
        out.append(rx['mm'][base + i % RX_TEXTN])
    return out.decode('ascii', 'replace'), tw


def fresh_iq(n):
    """n complex baseband samples that arrive after this call (from rxd's ring, or the FIFO without rxd)."""
    import numpy as np
    if rx_ok():
        w0 = rx_head()[10]
        t = time.time()
        while ((rx_head()[10] - w0) & 0xFFFFFFFF) < n and time.time() - t < 1.5:
            time.sleep(0.005)
        idx = (np.arange(w0, w0 + n) % RX_RING)
        blk = rx['ring'][idx].astype(np.float32)
        return blk[:, 0] + 1j * blk[:, 1]
    return capture_iq(n)


clients = {}
clients_lock = threading.Lock()
raw_clients = set()
raw_lock = threading.Lock()
scan_busy = threading.Event()


def ws_frame(payload, opcode=2):
    n = len(payload)
    return bytes([0x80 | opcode]) + (bytes([n]) if n < 126 else bytes([126]) + struct.pack('>H', n) if n < 65536
                                     else bytes([127]) + struct.pack('>Q', n)) + payload


def ws_send(sock, payload, opcode=2):
    """Queue a frame for one client. Each client has its own sender thread, so a slow or stuck browser
    only loses its own frames and never stalls the audio loop (or the other listeners)."""
    q = clients.get(sock)
    if q is None:
        raise OSError('client gone')
    try:
        q.put_nowait(ws_frame(payload, opcode))
    except queue.Full:
        pass                                    # this client is behind: drop the frame


def ws_sender(sock, q):
    try:
        while True:
            f = q.get()
            if f is None:
                return
            sock.sendall(f)
    except OSError:
        pass
    finally:
        with clients_lock:
            clients.pop(sock, None)


def broadcast(payload, opcode=2):
    with clients_lock:
        cs = list(clients)
    for c in cs:
        try:
            ws_send(c, payload, opcode)
        except OSError:
            with clients_lock:
                clients.pop(c, None)


def pump():
    """FPGA FIFO (or rxd's ring) -> browsers ([I, Q, audio] int16 per sample) and raw listeners (audio only)."""
    if rx_ok():
        return pump_rx()
    iqa, aud, last_meter = [], [], 0.0
    while True:
        if scan_busy.is_set():
            time.sleep(0.02)
            continue
        w = read_words()
        for k in range(0, len(w) - 1, 2):
            iq, am = w[k], w[k + 1]
            a = to16(am >> 16)
            iqa += (to16(iq >> 16), to16(iq & 0xFFFF), a)
            aud.append(a)
        if len(aud) >= 256:
            broadcast(struct.pack('<hh%dh' % len(iqa), 1, 0, *iqa))     # frame type 1: slice A
            pcm = struct.pack('<%dh' % len(aud), *aud)
            with raw_lock:
                rs = list(raw_clients)
            for c in rs:
                try:
                    c.sendall(pcm)
                except OSError:
                    with raw_lock:
                        raw_clients.discard(c)
                    c.close()
            iqa, aud = [], []
        now = time.time()
        if now - last_meter > 0.1:
            broadcast(json.dumps({'meter': meter}).encode(), opcode=1)
            last_meter = now
        time.sleep(0.01)


def send_raw(pcm):
    with raw_lock:
        rs = list(raw_clients)
    for c in rs:
        try:
            c.sendall(pcm)
        except OSError:
            with raw_lock:
                raw_clients.discard(c)
            c.close()


def pump_rx():
    import numpy as np
    last = rx_head()[10]
    last_meter = last_text = 0.0
    seen_text = rx_head()[15]
    img = {'seq': sstv_head()[0], 'sent': 0, 'saved': True, 'w': 0, 'h': 0, 'mode': '', 'rows': 0, 'last': 0.0}
    s_last = struct.unpack_from(RX_MULTI_HEAD, rx['mm'], RX_MULTI_OFF)[4]
    pan_seq = -1
    while True:
        w = rx_head()[10]
        n = (w - last) & 0xFFFFFFFF
        if n > RX_RING // 2:                         # fell behind: skip ahead
            last = (w - 2048) & 0xFFFFFFFF
            n = 2048
        if n >= 256:
            blk = rx['ring'][np.arange(last, last + n) % RX_RING]
            broadcast(b'\x01\x00\x00\x00' + blk.astype('<i2').tobytes())             # frame type 1: slice A
            send_raw(blk[:, 2].astype('<i2').tobytes())
            cydradio.SCREEN.feed_iq(blk[:, :2], FS, state['freq'] * 1000)       # CYD: only without a panadapter
            last = (last + n) & 0xFFFFFFFF
        if state['multi']:
            mh = struct.unpack_from(RX_MULTI_HEAD, rx['mm'], RX_MULTI_OFF)
            sw = mh[4]
            ns = (sw - s_last) & 0xFFFFFFFF
            if ns > RX_SRING // 2:
                s_last = (sw - 2048) & 0xFFFFFFFF
                ns = 2048
            if ns >= 256:
                idx = np.arange(s_last, s_last + ns) % RX_SRING
                for i, s in enumerate(state['slices']):
                    if s['on']:                                                       # frame types 2..4: slices B..D
                        broadcast(struct.pack('<hh', 2 + i, 0) + rx['sring'][idx, i, :].astype('<i2').tobytes())
                s_last = (s_last + ns) & 0xFFFFFFFF
            if mh[11] != pan_seq:                                                     # frame type 9: panadapter
                pan_seq = mh[11]
                center = mh[12] * FCLK / 4294967296.0
                db = np.frombuffer(rx['mm'], dtype='<f4', count=RX_PAN_N, offset=RX_PAN_OFF)
                q = np.clip(db * 100, -32768, 32767).astype('<i2')
                broadcast(struct.pack('<hhdd', 9, RX_PAN_N, center, FCLK / (1 << mh[13])) + q.tobytes())
                cydradio.SCREEN.feed_pan(db, center, FCLK / (1 << mh[13]))
        now = time.time()
        if now - last_meter > 0.1:
            if state['multi']:
                meter['slices'] = [round(v, 1) for v in struct.unpack_from('<3f', rx['mm'], RX_MULTI_OFF + 20)]
            broadcast(json.dumps({'meter': meter}).encode(), opcode=1)
            last_meter = now
        if now - last_text > 0.2:
            txt, seen_text = rx_text(seen_text)
            h = rx_head()
            broadcast(json.dumps({'dec': {'text': txt, 'wpm': round(h[12], 1), 'locked': h[14],
                                          'decoder': state['decoder']}}).encode(), opcode=1)
            last_text = now
            seq, w, h, rows, mode = sstv_head()
            if seq != img['seq']:                    # a new picture started: keep the old one if it got far enough
                if not img['saved']:
                    sstv_save(img['w'], img['h'], img['rows'], img['mode'])
                img.update(seq=seq, sent=0, saved=False, w=w, h=h, mode=mode, rows=0, last=now)
                broadcast(json.dumps({'sstv': {'new': 1, 'w': w, 'h': h, 'mode': mode}}).encode(), opcode=1)
            if 0 < w <= RX_IMG_W and 0 < h <= RX_IMG_H and rows > img['sent']:
                rows = min(rows, h)
                a = img['sent']
                broadcast(json.dumps({'sstv': {'w': w, 'h': h, 'mode': mode, 'row': a, 'n': rows - a,
                                               'rgb': base64.b64encode(sstv_rows(w, a, rows)).decode()}}).encode(), opcode=1)
                img.update(sent=rows, rows=rows, last=now)
            if not img['saved'] and img['rows'] and (img['rows'] >= h or now - img['last'] > 20):
                n = sstv_save(img['w'], img['h'], img['rows'], img['mode'])
                img['saved'] = True
                if n:
                    broadcast(json.dumps({'sstv': {'saved': n}}).encode(), opcode=1)
        time.sleep(0.01)


def scan(start, stop, stp):
    """Sweep the receiver and measure the carrier at each step (|IQ| straight from the capture FIFO)."""
    scan_busy.set()
    levels = []
    keep = dict(state)
    try:
        with lock:
            W(2, 6)                             # fixed RF gain while scanning, so the steps compare
        f = start
        while f <= stop + 1e-6:
            with lock:
                W(1, step(f * 1000))
            time.sleep(0.004)                   # CIC settles in < 1 ms
            z = fresh_iq(256)
            levels.append(round(float(abs(z).mean()), 1) if len(z) else 0)
            f += stp
        scan_result.update(start=start, step=stp, levels=levels)
    finally:
        state.update(keep)
        apply_all()
        scan_busy.clear()
    broadcast(json.dumps({'scan': scan_result}).encode(), opcode=1)


# ---------------------------------------------------------------- band plan (ITU Region 2 / US), kHz
# [low, high, name, usual mode, kind]  kind: band (a range) or stn (one known station / calling frequency)
BANDPLAN = [
    [3, 30, 'VLF', 'cw', 'band'], [24.0, 24.0, 'NAA Navy (Cutler, ME)', 'cw', 'stn'],
    [24.8, 24.8, 'NLK Navy (Jim Creek, WA)', 'cw', 'stn'], [25.2, 25.2, 'NML Navy (LaMoure, ND)', 'cw', 'stn'],
    [59.5, 60.5, 'WWVB time (60 kHz)', 'am', 'band'], [190, 535, 'NDB beacons', 'cw', 'band'],
    [530, 1700, 'AM broadcast', 'am', 'band'],
    [1800, 1840, '160 m CW', 'cw', 'band'], [1840, 1850, '160 m digital', 'usb', 'band'],
    [1850, 2000, '160 m phone', 'lsb', 'band'], [1840, 1840, 'FT8 160 m', 'usb', 'stn'],
    [2300, 2495, '120 m SW broadcast', 'am', 'band'], [2500, 2500, 'WWV 2.5 MHz', 'am', 'stn'],
    [3200, 3400, '90 m SW broadcast', 'am', 'band'], [3330, 3330, 'CHU time (Canada)', 'am', 'stn'],
    [3500, 3600, '80 m CW / digital', 'cw', 'band'], [3600, 4000, '80 m phone', 'lsb', 'band'],
    [3573, 3573, 'FT8 80 m', 'usb', 'stn'],
    [4750, 5060, '60 m SW broadcast', 'am', 'band'], [5000, 5000, 'WWV 5 MHz', 'am', 'stn'],
    [5330, 5410, '60 m ham channels', 'usb', 'band'], [5900, 6200, '49 m SW broadcast', 'am', 'band'],
    [7000, 7125, '40 m CW / digital', 'cw', 'band'], [7125, 7300, '40 m phone', 'lsb', 'band'],
    [7074, 7074, 'FT8 40 m', 'usb', 'stn'], [7300, 7450, '41 m SW broadcast', 'am', 'band'],
    [7850, 7850, 'CHU time (Canada)', 'am', 'stn'], [9400, 9900, '31 m SW broadcast', 'am', 'band'],
    [10000, 10000, 'WWV 10 MHz', 'am', 'stn'], [10100, 10150, '30 m CW / digital', 'cw', 'band'],
    [10136, 10136, 'FT8 30 m', 'usb', 'stn'], [11600, 12100, '25 m SW broadcast', 'am', 'band'],
    [13570, 13870, '22 m SW broadcast', 'am', 'band'],
    [14000, 14150, '20 m CW / digital', 'cw', 'band'], [14150, 14350, '20 m phone', 'usb', 'band'],
    [14074, 14074, 'FT8 20 m', 'usb', 'stn'], [14670, 14670, 'CHU time (Canada)', 'am', 'stn'],
    [15000, 15000, 'WWV 15 MHz', 'am', 'stn'], [15100, 15800, '19 m SW broadcast', 'am', 'band'],
    [17480, 17900, '16 m SW broadcast', 'am', 'band'],
    [18068, 18110, '17 m CW / digital', 'cw', 'band'], [18110, 18168, '17 m phone', 'usb', 'band'],
    [20000, 20000, 'WWV 20 MHz', 'am', 'stn'],
    [21000, 21200, '15 m CW / digital', 'cw', 'band'], [21200, 21450, '15 m phone', 'usb', 'band'],
    [21450, 21850, '13 m SW broadcast', 'am', 'band'],
    [24890, 24930, '12 m CW / digital', 'cw', 'band'], [24930, 24990, '12 m phone', 'usb', 'band'],
    [25670, 26100, '11 m SW broadcast', 'am', 'band'], [26965, 27405, 'CB (40 channels)', 'am', 'band'],
    [28000, 28300, '10 m CW / digital', 'cw', 'band'], [28300, 29700, '10 m phone', 'usb', 'band'],
    [29700, 50000, 'VHF low band (FM land mobile)', 'nfm', 'band'], [33000, 34000, 'Highway / fire low band', 'nfm', 'band'],
    [40660, 40700, 'ISM 40.68 MHz', 'nfm', 'band'], [43700, 44600, 'Old cordless phones (base)', 'nfm', 'band'],
    [46610, 46970, 'Old cordless phones', 'nfm', 'band'], [49660, 49990, '49 MHz baby monitors / walkie-talkies', 'nfm', 'band'],
]
DEMODS = ['am', 'sam', 'usb', 'lsb', 'cw', 'nfm']


def band_at(khz):
    """The most specific band-plan entry at khz (a known station within 0.5 kHz wins over a band)."""
    best = None
    for lo, hi, name, mode, kind in BANDPLAN:
        if kind == 'stn' and abs(khz - lo) <= 0.5:
            return {'name': name, 'mode': mode}
        if kind == 'band' and lo <= khz <= hi and (best is None or hi - lo < best[0]):
            best = (hi - lo, name, mode)
    return {'name': best[1], 'mode': best[2]} if best else {'name': '', 'mode': ''}


# ---------------------------------------------------------------- memories (auto-programmed + your own)
MEM_FILE = os.path.join(HERE, 'memories.json')
try:
    memories = json.load(open(MEM_FILE))
except (OSError, ValueError):
    memories = {'channels': [], 'birdies': []}


def save_memories():
    tmp = MEM_FILE + '.tmp'
    json.dump(memories, open(tmp, 'w'), indent=1)
    os.replace(tmp, MEM_FILE)


def broadcast_memories():
    broadcast(json.dumps({'memories': memories}).encode(), opcode=1)


def is_birdie(khz):
    return any(abs(khz - b) <= 0.3 for b in memories['birdies'])


# ---------------------------------------------------------------- wide scan: FFT each 10 kHz window, find + classify
def capture_iq(n):
    """n complex baseband samples from the capture FIFO (caller holds scan_busy so the pump stays out)."""
    import numpy as np
    out, t = [], time.time()
    while len(out) < 2 * n and time.time() - t < 1.0:
        w = read_words()
        out += w[0::2]
        if len(out) < 2 * n:
            time.sleep(0.004)
    a = np.array(out[:n], dtype=np.uint32)
    i = (a >> 16).astype(np.int16).astype(np.float32)
    q = (a & 0xFFFF).astype(np.uint16).astype(np.int16).astype(np.float32)
    return i + 1j * q


def classify(z):
    """Guess the mode of the signal at the center of a 12 kHz baseband snapshot."""
    import numpy as np
    n = len(z)
    if n < 256:
        return 'am', 0.0
    X = np.fft.fftshift(np.fft.fft(z * np.hanning(n)))
    p = np.abs(X) ** 2
    f = (np.arange(n) - n // 2) * FS / n
    tot = p[np.abs(f) < 4500].sum() + 1e-9
    car = p[np.abs(f) < 40].sum() / tot
    up = p[(f > 250) & (f < 3500)].sum()
    lo = p[(f < -250) & (f > -3500)].sum()
    side = (up + lo) / tot
    env = np.abs(z)
    keying = float(np.std(env) / (np.mean(env) + 1e-9))      # on/off keying (CW) moves the envelope a lot
    if car > 0.6 and side < 0.15:
        return ('cw' if keying > 0.5 else 'carrier'), car
    if car > 0.25 and min(up, lo) > 0.3 * max(up, lo):
        return 'am', car
    if side > 0.4 and up > 3 * lo:
        return 'usb', car
    if side > 0.4 and lo > 3 * up:
        return 'lsb', car
    ph = np.angle(z[1:] * np.conj(z[:-1]))
    if np.std(ph) > 0.6 and np.std(env) / (np.mean(env) + 1e-9) < 0.25:
        return 'nfm', car
    return 'am', car


wscan = {'busy': False, 'progress': 0.0, 'hits': [], 'stop': False}


def wide_scan(start, stop, thresh_db=12.0, program=True):
    try:
        _wide_scan(start, stop, thresh_db, program)
    except Exception:  # noqa: BLE001
        import traceback
        traceback.print_exc()
        sys.stdout.flush()


def _wide_scan(start, stop, thresh_db=12.0, program=True):
    """Sweep start..stop kHz in 9 kHz hops; FFT each window; keep peaks thresh_db over the window's noise floor;
    then tune to each hit, classify it and (optionally) auto-program it into the memories."""
    import numpy as np
    scan_busy.set()
    wscan.update(busy=True, progress=0.0, hits=[], stop=False)
    keep = dict(state)
    hits = []
    try:
        with lock:
            W(2, 4)
            W(3, 2048)
        N, hop = 256, 9.0                       # 4 x 256 samples = 84 ms per window, 48 Hz bins; 9 kHz hops overlap
        f0 = start
        nsteps = max(1, int((stop - start) / hop) + 1)
        k = 0
        last_push = 0.0
        while f0 <= stop + 1e-6 and not wscan['stop']:
            with lock:
                W(1, step(f0 * 1000))
            time.sleep(0.004)
            z = fresh_iq(4 * N)
            if len(z) >= 4 * N:
                # Welch: average 4 spectra so noise peaks shrink and only steady signals stand out
                win = np.hanning(N)
                P = sum(np.abs(np.fft.fftshift(np.fft.fft(z[k * N:(k + 1) * N] * win))) ** 2 for k in range(4)) / 4
                pdb = 10 * np.log10(P + 1)
                fr = (np.arange(N) - N // 2) * FS / N
                use = np.abs(fr) <= 4600
                floor = np.median(pdb[use])
                for i in np.where(use & (pdb > floor + thresh_db))[0]:
                    if 0 < i < N - 1 and pdb[i] >= pdb[i - 1] and pdb[i] >= pdb[i + 1]:
                        khz = f0 + fr[i] / 1000.0
                        if abs(fr[i]) < 30:              # the mixer's own DC spot: skip, a later window sees it
                            continue
                        hits.append([round(khz, 3), round(float(pdb[i] - floor), 1)])
            k += 1
            f0 += hop
            wscan['progress'] = k / nsteps
            if time.time() - last_push > 0.3:
                broadcast(json.dumps({'wscan': {'busy': True, 'progress': wscan['progress'], 'found': len(hits),
                                                'at': round(f0, 1)}}).encode(), opcode=1)
                last_push = time.time()
        # merge peaks closer than 0.4 kHz (the same signal seen from two windows), strongest wins
        hits.sort(key=lambda h: -h[1])
        merged = []
        for khz, snr in hits:
            if not is_birdie(khz) and all(abs(khz - m[0]) > 0.4 for m in merged):
                merged.append([khz, snr])
        merged = merged[:150]
        # classify each: tune right onto it and look at the spectrum shape
        out = []
        for i, (khz, snr) in enumerate(sorted(merged)):
            if wscan['stop']:
                break
            with lock:
                W(1, step(khz * 1000))
            time.sleep(0.004)
            mode, car = classify(fresh_iq(1024))
            b = band_at(khz)
            if mode in ('carrier', 'am') and b['mode'] in ('usb', 'lsb', 'cw') and car < 0.6:
                mode = b['mode']
            out.append({'freq': khz, 'mode': mode if mode != 'carrier' else 'am', 'kind': mode, 'snr': snr,
                        'label': b['name'], 'auto': True})
            if time.time() - last_push > 0.3:
                broadcast(json.dumps({'wscan': {'busy': True, 'progress': 1.0, 'found': len(merged),
                                                'classified': i + 1}}).encode(), opcode=1)
                last_push = time.time()
        wscan['hits'] = out
        if program:
            mine = [c for c in memories['channels'] if not c.get('auto') or not (start <= c['freq'] <= stop)]
            memories['channels'] = sorted(mine + out, key=lambda c: c['freq'])
            save_memories()
    finally:
        state.update(keep)
        apply_all()
        scan_busy.clear()
        wscan['busy'] = False
    broadcast(json.dumps({'wscan': {'busy': False, 'progress': 1.0, 'found': len(wscan['hits']),
                                    'hits': wscan['hits']}}).encode(), opcode=1)
    broadcast_memories()


def full_state():
    return {'state': state, 'fs': FS, 'meter': meter, 'scan': scan_result, 'modes': list(MODES),
            'bandplan': BANDPLAN, 'demods': DEMODS, 'memories': memories,
            'wscan': {'busy': wscan['busy'], 'progress': wscan['progress'], 'hits': wscan['hits']},
            'decoders': DECODERS, 'dec_text': rx_text(max(0, rx_head()[15] - 3000))[0] if rx_ok() else ''}


def handle(m):
    if 'set' in m:
        for k, v in m['set'].items():
            set_param(k, v)
        broadcast(json.dumps({'state': state}).encode(), opcode=1)
    elif 'scan' in m and not scan_busy.is_set():
        s = m['scan']
        threading.Thread(target=scan, args=(float(s['start']), float(s['stop']), float(s['step'])), daemon=True).start()
    elif 'wscan' in m:
        s = m['wscan']
        if s.get('cancel'):
            wscan['stop'] = True
        elif not scan_busy.is_set():
            print('wide scan %s..%s kHz' % (s['start'], s['stop']), flush=True)
            threading.Thread(target=wide_scan, args=(float(s['start']), float(s['stop']), float(s.get('thresh', 12)),
                                                     bool(s.get('program', True))), daemon=True).start()
    elif 'slice' in m:
        set_slice(m['slice'])
        broadcast(json.dumps({'state': state}).encode(), opcode=1)
    elif 'pan' in m:
        set_pan(m['pan'])
        broadcast(json.dumps({'state': state}).encode(), opcode=1)
    elif 'dec_clear' in m:
        rx_push(cmd=1)
    elif 'mem_add' in m:
        c = m['mem_add']
        f = float(c['freq'])
        b = band_at(f)
        auto = bool(c.get('auto'))
        near = [x for x in memories['channels'] if abs(x['freq'] - f) <= 0.05]
        if auto and any(not x.get('auto') for x in near):
            return
        channel = {'freq': f, 'mode': c.get('mode', 'am'), 'kind': 'carrier' if auto else 'saved',
                   'snr': float(c.get('snr', 0)) if auto else 0, 'label': c.get('label') or b['name'], 'auto': auto}
        memories['channels'] = sorted([x for x in memories['channels'] if abs(x['freq'] - f) > 0.05] +
                                      [channel], key=lambda x: x['freq'])
        save_memories()
        broadcast_memories()
    elif 'mem_del' in m:
        f = float(m['mem_del'])
        memories['channels'] = [x for x in memories['channels'] if abs(x['freq'] - f) > 0.0005]
        save_memories()
        broadcast_memories()
    elif 'birdie' in m:
        f = float(m['birdie'])
        memories['birdies'].append(f)
        memories['channels'] = [x for x in memories['channels'] if abs(x['freq'] - f) > 0.3]
        save_memories()
        broadcast_memories()
    elif 'mem_clear' in m:
        memories['channels'] = [x for x in memories['channels'] if not x.get('auto')] if m['mem_clear'] == 'auto' else []
        save_memories()
        broadcast_memories()


# ---------------------------------------------------------------- web server (stdlib)
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


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def do_GET(self):
        if self.path.startswith('/ws') and self.headers.get('Upgrade', '').lower() == 'websocket':
            key = self.headers['Sec-WebSocket-Key']
            acc = base64.b64encode(hashlib.sha1((key + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').encode()).digest())
            self.send_response(101)
            self.send_header('Upgrade', 'websocket')
            self.send_header('Connection', 'Upgrade')
            self.send_header('Sec-WebSocket-Accept', acc.decode())
            self.end_headers()
            self.wfile.flush()
            sock = self.connection
            q = queue.Queue(maxsize=64)
            with clients_lock:
                clients[sock] = q
            threading.Thread(target=ws_sender, args=(sock, q), daemon=True).start()
            ws_send(sock, json.dumps(full_state()).encode(), opcode=1)
            try:
                while True:
                    op, data = ws_recv(self.rfile)
                    if op is None or op == 8:
                        break
                    if op == 1:
                        if os.environ.get('RADIO_DEBUG'):
                            print('ws in:', data[:120], flush=True)
                        try:
                            handle(json.loads(data))
                        except Exception:  # noqa: BLE001  (a bad message must not drop the browser)
                            import traceback
                            traceback.print_exc()
                            sys.stdout.flush()
            except (OSError, ValueError, KeyError, TypeError):
                pass
            finally:
                with clients_lock:
                    q = clients.pop(sock, None)
                if q is not None:
                    q.put(None)
            return
        if self.path.startswith('/sstv/'):
            name = os.path.basename(self.path.split('?')[0])
            fp = os.path.realpath(os.path.join(SSTV_DIR, name))
            if not fp.startswith(os.path.realpath(SSTV_DIR) + os.sep):
                self.send_error(404)
                return
            if name == 'list':
                files = sorted((f for f in os.listdir(SSTV_DIR) if f.endswith('.png') and f != 'latest.png'),
                               reverse=True) if os.path.isdir(SSTV_DIR) else []
                body, ctype = json.dumps(files).encode(), 'application/json'
            elif name.endswith('.png') and os.path.isfile(fp):
                body, ctype = open(fp, 'rb').read(), 'image/png'
            else:
                self.send_error(404)
                return
            self.send_response(200)
            self.send_header('Content-Type', ctype)
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
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
    import socket
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
    state['multi'] = 1 if (R(27) & 0xFF) >= 4 else 0       # tuners B..D + wide panadapter in this FPGA build
    print('tuners: %d, wide panadapter: %s' % (4 if state['multi'] else 1, 'yes' if state['multi'] else 'no'), flush=True)
    apply_all()
    try:
        bus.wr(14, 1, 0x3333)                   # D5..D8: signal-strength bar
    except Exception:  # noqa: BLE001
        pass
    if rx_start():
        state['board_dsp'] = 1
        print('rxd: demodulators, filters and decoders run on the board', flush=True)
    # the ORPHAN Remote (CYD named in /etc/orphan/cyd): frequency, modes, spectrum and waterfall, 4 times a second
    if os.environ.get('ORPHAN_RADIO_CYD', '1') != '0':
        threading.Thread(target=cydradio.run, daemon=True, args=(
            lambda: state, lambda: meter,
            lambda: (rx_text(max(0, rx_head()[15] - 400))[0] if state['decoder'] != 'off' and rx_ok() else ''))).start()
    for t in (pump, control_loop, melody_loop, raw_audio_server):
        threading.Thread(target=t, daemon=True).start()
    ip = subprocess.run(['hostname', '-I'], capture_output=True, text=True).stdout.split()[0]
    print('Orphan Radio: open http://%s:%d in a browser' % (ip, PORT))
    print('Hear it on your PC: ffplay -nodisp -f s16le -ar 12207 -ch_layout mono -fflags nobuffer tcp://%s:8001' % ip,
          flush=True)
    Server(('', PORT), Handler).serve_forever()
