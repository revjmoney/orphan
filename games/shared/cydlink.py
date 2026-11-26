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


def encode_rows(rows):
    """rows: (n, w) uint8 (palette index) or uint16 (RGB565). Returns one bytes object per row, each
    u8 encoding (0 raw, 1 runs) + u16 length + data; runs are (u8 count-1, value) pairs, never crossing a row."""
    n, w = rows.shape
    pb = rows.dtype.itemsize
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
    out = []
    for r in range(n):
        k = int(runs_per_row[r])
        if k * (1 + pb) < w * pb:
            data = rec[first[r]:first[r] + k].tobytes()
            out.append(struct.pack('<BH', 1, len(data)) + data)
        else:
            data = raw[r].tobytes()
            out.append(struct.pack('<BH', 0, len(data)) + data)
    return out


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


class CydLinkUdp:
    """The same pictures over UDP 8093: the ESP32's TCP stops near 480 KB/s, its Wi-Fi takes about 1.8 MB/s of UDP.

    Each packet holds whole rows (whole pairs at 1.5x) and is drawn as it lands. END asks which packets arrived;
    rows of a lost packet are sent again with the next picture. Packets are paced (rate in bytes/s) so the CYD's
    small receive queue is never flooded. Same send() as CydLink."""

    PACKET = 1400

    def __init__(self, host, port=8093, rate=1200000, timeout=0.08):
        self.addr, self.rate, self.timeout = (host, port), rate, timeout
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.settimeout(timeout)
        self.prev, self.layout, self.gen, self.pic = None, None, 0, 0
        self.stale = None                     # rows the CYD may not have (lost packets)
        self.sent_bytes, self.lost = 0, 0
        self.misses = 0                       # pictures in a row with no answer (the CYD restarted?)
        self.pending = None                   # (pic, packets, rows, END packet) still waiting for its answer

    def close(self):
        self.prev, self.layout, self.pending = None, None, None

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
            if self._recv(b'M'):
                return
        raise OSError('the CYD does not answer on UDP')

    def _finish(self):
        """Collect the CYD's answer to the picture sent last time (it drew while we encoded this one): sets
        self.stale to the rows it did not get. END is sent again every 20 ms in case it was lost."""
        if self.pending is None:
            return
        pic, packets, h, endpkt = self.pending
        self.pending = None
        reply = self._recv(b'K', 0.03)
        for _ in range(4):
            if reply:
                break
            self.sock.sendto(endpkt, self.addr)
            reply = self._recv(b'K', 0.02)
        stale = np.zeros(h, dtype=bool)
        if reply is None or len(reply) < 12:
            for r0, n, _ in packets:                    # no answer: assume nothing arrived
                stale[r0:r0 + n] = True
            self.lost += len(packets)
            self.misses += 1
            if self.misses >= 3:                        # it forgot the layout (restarted): send MODE again next time
                self.layout, self.misses = None, 0
        else:
            self.misses = 0
            got = struct.unpack_from('<Q', reply, 4)[0]
            for i, (r0, n, _) in enumerate(packets):
                if not got >> i & 1:
                    stale[r0:r0 + n] = True
                    self.lost += 1
        self.stale = stale if self.stale is None or self.stale.shape != stale.shape else self.stale | stale

    def send(self, img, scale=0, x=0, y=0, palette=None, hud=False):
        """Send one picture. Pipelined: the CYD's answer to the previous picture is collected after this one is
        encoded, so encoding here and drawing there overlap."""
        h, w = img.shape
        pb = img.dtype.itemsize
        pal = b'' if palette is None else np.asarray(palette, dtype='<u2').tobytes()
        layout = (pb, scale, w, h, x, y, pal, hud)
        unit = 2 if scale else 1                       # rows that must travel together
        same = layout == self.layout and self.prev is not None and self.prev.shape == img.shape
        changed = (img != self.prev).any(axis=1) if same else np.ones(h, dtype=bool)
        rows = encode_rows(img) if changed.any() else None
        self._finish()
        if not same or self.layout is None:
            self._mode(struct.pack('<BBBBHHHHH', pb, scale, 1 if hud else 0, 0, w, h, x, y, len(pal) // 2) + pal)
            self.layout, self.prev, self.stale = layout, None, None
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
        self.pending = (self.pic, packets, h, endpkt)
        self.prev = img.copy()
        self.sent_bytes += total
        return total
