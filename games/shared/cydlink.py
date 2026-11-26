# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""ORPHAN Remote game stream (CYD, TCP 8092): only the rows that changed, palette indices, run-length rows.

One TCP connection stays open. Per picture: MODE (only when the layout changes or after a reconnect), ROWS blocks
for the changed rows, END; the CYD answers 'K' once it has drawn the picture, so at most one picture is in flight
and the newest one always goes next. Pure numpy + sockets: runs on the board and on a PC (tools/cyd_game_bench.py).
by JMSCNC, makers of RotatoCAM.
"""
import os
import socket
import time
import struct

import numpy as np

MODE, ROWS, END = 1, 2, 3

# ---------------------------------------------------------------- console colours as RGB565 (shared with main.py)
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

ROWS_PER_BLOCK = 16


def _msg(kind, payload=b''):
    return struct.pack('<BI', kind, len(payload)) + payload


def _load_fast():
    """cydfast.c compiled on the board (gcc), through ctypes; None where there is no compiler (the PC bench)."""
    if os.name == 'nt':
        return None
    try:
        import ctypes
        import subprocess
        src = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'cydfast.c')
        so = '/tmp/cydfast-%d.so' % int(os.path.getmtime(src))
        if not os.path.exists(so):
            subprocess.run(['gcc', '-O2', '-shared', '-fPIC', '-o', so + '.tmp', src], check=True, timeout=60,
                           capture_output=True)
            os.replace(so + '.tmp', so)
        lib = ctypes.CDLL(so)
        lib.unpack6.restype = None
        lib.enc8.restype = ctypes.c_int
        return lib
    except Exception as e:                    # no gcc, or it failed: numpy does it (slower)
        print('cydlink: fast path off (%s)' % e, flush=True)
        return None


_fast = _load_fast()


def unpack6(fb, npix):
    """Frame buffer bytes (5 pixels of 6 bits per 32-bit word, pixel 0 in [5:0]) -> uint8 array of npix pixels."""
    nw = len(fb) // 4
    if _fast is not None:
        out = np.empty(nw * 5, dtype=np.uint8)
        src = np.frombuffer(fb, dtype=np.uint32)
        _fast.unpack6(src.ctypes.data, nw, out.ctypes.data)
        return out[:npix]
    w = np.frombuffer(fb, dtype=np.uint32)[:, None]
    return ((w >> np.arange(0, 30, 6, dtype=np.uint32)) & 63).astype(np.uint8).reshape(-1)[:npix]


def encode_rows(rows):
    """rows: (n, w) uint8 (palette index) or uint16 (RGB565). Returns one bytes object per row, each
    u8 encoding (0 raw, 1 runs) + u16 length + data; runs are (u8 count-1, value) pairs, never crossing a row."""
    n, w = rows.shape
    pb = rows.dtype.itemsize
    if _fast is not None and pb == 1:
        img = np.ascontiguousarray(rows)
        out = np.empty(n * (3 + 2 * w), dtype=np.uint8)
        off = np.empty(n + 1, dtype=np.int32)
        _fast.enc8(img.ctypes.data, n, w, out.ctypes.data, off.ctypes.data)
        blob = memoryview(out[:int(off[n])].tobytes())
        o = off.tolist()
        return [blob[o[r]:o[r + 1]] for r in range(n)]
    flat = rows.reshape(-1)
    brk = np.empty(flat.size, dtype=bool)
    brk[0] = True
    brk[1:] = flat[1:] != flat[:-1]
    brk[::w] = True                                    # every row starts a new run
    starts = np.flatnonzero(brk)
    counts = np.diff(np.append(starts, flat.size))     # <= w <= 256, so count-1 fits a byte
    rec = np.empty(starts.size, dtype=[('c', 'u1'), ('v', '<u2' if pb == 2 else 'u1')])
    rec['c'] = counts - 1
    rec['v'] = flat[starts]
    runs_per_row = np.bincount(starts // w, minlength=n)
    first = np.concatenate(([0], np.cumsum(runs_per_row)))
    raw = rows.astype('<u2' if pb == 2 else 'u1', copy=False)
    # every row as u8 enc + u16 length + data, built in one gather (no Python loop per row)
    use_runs = runs_per_row * (1 + pb) < w * pb
    dlen = np.where(use_runs, runs_per_row * (1 + pb), w * pb)
    hdr = np.empty((n, 3), dtype=np.uint8)
    hdr[:, 0] = use_runs
    hdr[:, 1] = dlen & 255
    hdr[:, 2] = dlen >> 8
    runb = rec.view(np.uint8)
    rawb = raw.reshape(-1).view(np.uint8)
    src = np.concatenate((hdr.reshape(-1), runb, rawb))
    base_run, base_raw = 3 * n, 3 * n + runb.size
    dsrc = np.where(use_runs, base_run + first[:-1] * (1 + pb), base_raw + np.arange(n) * (w * pb))
    seg_src = np.empty(2 * n, dtype=np.intp)
    seg_len = np.empty(2 * n, dtype=np.intp)
    seg_src[0::2], seg_len[0::2] = np.arange(n) * 3, 3
    seg_src[1::2], seg_len[1::2] = dsrc, dlen
    ends = np.cumsum(seg_len)
    total = int(ends[-1])
    idx = np.arange(total, dtype=np.intp) + np.repeat(seg_src - (ends - seg_len), seg_len)
    blob = memoryview(src[idx].tobytes())
    rend = ends[1::2]
    rstart = np.concatenate(([0], rend[:-1]))
    return [blob[int(a):int(b)] for a, b in zip(rstart, rend)]


class CydLink:
    """Send pictures to an ORPHAN Remote. layout = (pixel_bytes, scale, x, y, palette or None)."""

    def __init__(self, host, port=8092, timeout=2.0):
        self.host, self.port, self.timeout = host, port, timeout
        self.sock, self.prev, self.layout = None, None, None
        self.sent_bytes = 0

    def close(self):
        if self.sock:
            try:
                self.sock.close()
            except OSError:
                pass
        self.sock, self.prev, self.layout = None, None, None

    def _connect(self):
        s = socket.create_connection((self.host, self.port), timeout=self.timeout)
        s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        self.sock, self.prev, self.layout = s, None, None

    def send(self, img, scale=0, x=0, y=0, palette=None, hud=False):
        """img: (h, w) uint8 indices into palette (list/array of RGB565) or uint16 RGB565. scale 0 = 1x, 1 = 1.5x.
        Returns the bytes sent for this picture. Raises OSError if the CYD is gone (the next call reconnects)."""
        if self.sock is None:
            self._connect()
        h, w = img.shape
        pb = img.dtype.itemsize
        pal = b'' if palette is None else np.asarray(palette, dtype='<u2').tobytes()
        layout = (pb, scale, w, h, x, y, pal, hud)
        parts = []
        if layout != self.layout or self.prev is None or self.prev.shape != img.shape:
            parts.append(_msg(MODE, struct.pack('<BBBBHHHHH', pb, scale, 1 if hud else 0, 0, w, h, x, y,
                                                len(pal) // 2) + pal))
            changed = np.ones(h, dtype=bool)
        else:
            changed = (img != self.prev).any(axis=1)
        if scale:                                       # 1.5x draws row pairs: send whole pairs
            pair = changed.reshape(-1, 2).any(axis=1)
            changed = np.repeat(pair, 2)
        idx = np.flatnonzero(changed)
        if idx.size:
            # consecutive runs of changed rows, cut into blocks
            cut = np.flatnonzero(np.diff(idx) != 1) + 1
            for grp in np.split(idx, cut):
                for b0 in range(0, grp.size, ROWS_PER_BLOCK):
                    r0, r1 = int(grp[b0]), int(grp[min(b0 + ROWS_PER_BLOCK, grp.size) - 1]) + 1
                    if scale and (r1 - r0) & 1:
                        r1 += 1
                    body = b''.join(encode_rows(img[r0:r1]))
                    parts.append(_msg(ROWS, struct.pack('<HH', r0, r1 - r0) + body))
        parts.append(_msg(END))
        data = b''.join(parts)
        try:
            self.sock.sendall(data)
            ack = self.sock.recv(1)
            if ack != b'K':
                raise OSError('no ack from the CYD')
        except OSError:
            self.close()
            raise
        self.prev, self.layout = img.copy(), layout
        self.sent_bytes += len(data)
        return len(data)


class CydBusy(Exception):
    """The CYD is showing a higher-priority stream (a video): try again later (not an error)."""


class CydLinkUdp:
    """The same pictures over UDP 8093: the ESP32's TCP stops near 480 KB/s, its Wi-Fi takes about 1.8 MB/s of UDP.

    Each packet holds whole rows (whole pairs at 1.5x) and is drawn as it lands. END asks which packets arrived;
    rows of a lost packet are sent again with the next picture. Packets are paced (rate in bytes/s) so the CYD's
    small receive queue is never flooded. Same send() as CydLink."""

    PACKET = 1400

    def __init__(self, host, port=8093, rate=1200000, timeout=0.08, priority=0):
        self.addr, self.rate, self.timeout = (host, port), rate, timeout
        self.priority = priority              # 0 games, 1 video: a video holds the screen, games get CydBusy
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.settimeout(timeout)
        self.prev, self.layout, self.gen, self.pic = None, None, 0, 0
        self.stale = None                     # rows the CYD may not have (lost packets)
        self.sent_bytes, self.lost = 0, 0
        self.misses = 0                       # pictures in a row with no answer (the CYD restarted?)
        self.inflight = {}                    # pic -> (time sent, packets, rows, END packet, END resent)

    def close(self):
        self.prev, self.layout = None, None
        self.inflight = {}

    def _recv(self, want, timeout=None):
        end = time.perf_counter() + (self.timeout if timeout is None else timeout)
        while True:
            left = end - time.perf_counter()
            if left <= 0:
                return None
            try:
                self.sock.settimeout(left)               # never block past this wait's own end
                d, _ = self.sock.recvfrom(64)
            except socket.timeout:
                return None
            except OSError:
                return None
            if d[:1] == want and len(d) >= 2 and d[1] == self.gen:
                if want == b'K' and (len(d) < 4 or struct.unpack_from('<H', d, 2)[0] != self.pic):
                    continue                             # a late answer to an earlier picture: skip it
                return d
        return None

    def _mode(self, payload):
        self.gen = (self.gen + 1) & 255
        pkt = struct.pack('<BBH', MODE, self.gen, self.pic) + payload
        for _ in range(8):
            self.sock.sendto(pkt, self.addr)
            end = time.perf_counter() + self.timeout
            while time.perf_counter() < end:
                try:
                    self.sock.settimeout(max(0.001, end - time.perf_counter()))
                    d, _ = self.sock.recvfrom(64)
                except OSError:
                    break
                if len(d) >= 2 and d[1] == self.gen and d[:1] == b'M':
                    return
                if len(d) >= 2 and d[1] == self.gen and d[:1] == b'B':
                    self.layout, self.prev = None, None
                    raise CydBusy('the CYD is showing a video')
        raise OSError('the CYD does not answer on UDP')

    FLY = 3                                   # pictures that may wait for their answer at once
    ANSWER_S = 0.25                           # no answer by then: count its rows as lost

    def _mark(self, h, packets, got):
        if self.stale is None or self.stale.shape != (h,):
            self.stale = np.zeros(h, dtype=bool)
        for i, (r0, n, _) in enumerate(packets):
            if not got >> i & 1:
                self.stale[r0:r0 + n] = True
                self.lost += 1

    def _collect(self):
        """Take in the CYD's answers (K: which packets of a picture arrived) as they come, without waiting for
        them: rows it did not get go again with the next picture. Waits only while FLY pictures are unanswered.
        (Waiting for every answer made each Wi-Fi delay a stall: an answer is usually 3 ms, 1 in 10 is 15-120.)"""
        try:
            self._collect_loop()
        finally:
            self.sock.settimeout(self.timeout)          # (sendto must not be non-blocking)

    def _collect_loop(self):
        while True:
            now = time.perf_counter()
            for pic in list(self.inflight):              # too old: assume none of it arrived
                t, packets, h, endpkt, resent = self.inflight[pic]
                if now - t > self.ANSWER_S:
                    del self.inflight[pic]
                    self._mark(h, packets, 0)
                    self.misses += 1
                    if self.misses >= 6:                 # it forgot the layout (restarted): MODE again
                        self.layout, self.misses = None, 0
                        self.inflight.clear()
                        return
                elif not resent and now - t > 0.04:      # END may be lost: ask once more
                    self.sock.sendto(endpkt, self.addr)
                    self.inflight[pic] = (t, packets, h, endpkt, True)
            if not self.inflight:
                return
            if len(self.inflight) < self.FLY:
                wait = 0.0
            else:
                oldest = min(v[0] for v in self.inflight.values())
                wait = min(0.02, max(0.001, oldest + self.ANSWER_S - now))
            try:
                if wait:
                    self.sock.settimeout(wait)
                else:
                    self.sock.setblocking(False)
                d, _ = self.sock.recvfrom(64)
            except (socket.timeout, BlockingIOError):
                if len(self.inflight) < self.FLY:
                    return
                continue
            except OSError:
                return
            if d[:1] == b'K' and len(d) >= 12 and d[1] == self.gen:
                pic = struct.unpack_from('<H', d, 2)[0]
                if pic in self.inflight:
                    _, packets, h, _, _ = self.inflight.pop(pic)
                    self._mark(h, packets, struct.unpack_from('<Q', d, 4)[0])
                    self.misses = 0

    def send(self, img, scale=0, x=0, y=0, palette=None, hud=False):
        """Send one picture. The CYD's answers are taken in as they arrive (see _collect), so neither encoding
        here nor a slow answer holds up the stream."""
        h, w = img.shape
        pb = img.dtype.itemsize
        pal = b'' if palette is None else np.asarray(palette, dtype='<u2').tobytes()
        layout = (pb, scale, w, h, x, y, pal, hud)
        unit = 2 if scale else 1                       # rows that must travel together
        same = layout == self.layout and self.prev is not None and self.prev.shape == img.shape
        changed = (img != self.prev).any(axis=1) if same else np.ones(h, dtype=bool)
        rows = encode_rows(img) if changed.any() else None
        self._collect()
        if not same or self.layout is None:
            self._mode(struct.pack('<BBBBHHHHH', pb, scale, 1 if hud else 0, self.priority, w, h, x, y, len(pal) // 2)
                       + pal)
            self.layout, self.prev, self.stale = layout, None, None
            self.inflight.clear()
            changed = np.ones(h, dtype=bool)
        if self.stale is not None and self.stale.shape == changed.shape:
            changed = changed | self.stale
        self.stale = None
        if scale:
            changed = np.repeat(changed.reshape(-1, 2).any(axis=1), 2)
        if rows is None and changed.any():
            rows = encode_rows(img)
        # pack consecutive changed units into packets of at most PACKET bytes
        packets, cur, cur_r0, cur_n, cur_len = [], [], None, 0, 0
        for r0 in range(0, h, unit):
            if not changed[r0]:
                if cur:
                    packets.append((cur_r0, cur_n, b''.join(cur)))
                    cur, cur_r0, cur_n, cur_len = [], None, 0, 0
                continue
            blob = b''.join(rows[r0:r0 + unit])
            if cur and cur_len + len(blob) > self.PACKET - 9:
                packets.append((cur_r0, cur_n, b''.join(cur)))
                cur, cur_r0, cur_n, cur_len = [], None, 0, 0
            if not cur:
                cur_r0 = r0
            cur.append(blob)
            cur_n += unit
            cur_len += len(blob)
        if cur:
            packets.append((cur_r0, cur_n, b''.join(cur)))
        if len(packets) > 64:
            raise ValueError('picture needs more than 64 packets')
        self.pic = (self.pic + 1) & 0xFFFF
        t, total = time.perf_counter(), 0
        for i, (r0, n, body) in enumerate(packets):
            pkt = struct.pack('<BBHBHH', ROWS, self.gen, self.pic, i, r0, n) + body
            self.sock.sendto(pkt, self.addr)
            total += len(pkt)
            wait = total / self.rate - (time.perf_counter() - t)
            if wait > 0:
                if os.name == 'nt':                      # Windows sleep is ~15 ms coarse: busy wait (PC bench only)
                    while time.perf_counter() - t < total / self.rate:
                        pass
                else:                                    # Linux: a real sleep, so other threads (ROM upload) keep running
                    time.sleep(wait)
        endpkt = struct.pack('<BBHB', END, self.gen, self.pic, len(packets))
        self.sock.sendto(endpkt, self.addr)
        self.inflight[self.pic] = (time.perf_counter(), packets, h, endpkt, False)
        self.prev = img.copy()
        self.sent_bytes += total
        return total
