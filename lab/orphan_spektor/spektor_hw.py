"""SPEKTOR on the board: arm the FPGA capture core, wait for the trigger, read the ring back as runs of samples.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import time

import numpy as np

from blocks import Bus, require

SLOT = 1
RING = 16384
# the 36 header pins, in the core's order: J1.5 J1.11 J1.12 J1.15, J2.5 ... J9.15
PIN_NAMES = ['J%d.%d' % (n, p) for n in range(1, 10) for p in (5, 11, 12, 15)]
DEFAULT_MAP = list(range(20, 36))          # CH0..15 = J6, J7, J8, J9 (the S9's stock headers first)


class Spektor:
    def __init__(self):
        self.bus = Bus()
        require(self.bus, 'SPK1')
        mm = self.bus.m
        self.w = mm._w
        self.base = (mm._off >> 2) + SLOT * 1024
        self.wnp = np.frombuffer(mm._m, dtype=np.uint32)
        self.popv = np.full(RING, self.base + 768)

    def wr(self, i, v):
        self.w[self.base + i] = int(v) & 0xFFFFFFFF

    def rd(self, i):
        return int(self.w[self.base + i])

    def live(self):
        return self.rd(8)

    def status(self):
        s = self.rd(1)
        return {'armed': bool(s & 1), 'triggered': bool(s & 2), 'done': bool(s & 4), 'rle': bool(s & 8),
                'filled': self.rd(7), 'samples': self.rd(9), 'live': self.rd(8)}

    def arm(self, div=0, rle=False, test=False, post=8192, stages=()):
        """stages: up to 4 dicts {mask, value, rise, fall, count} (channel bit masks; a channel in rise and fall =
        any edge). No stages = trigger now."""
        self.wr(0, 2)                                     # stop
        self.wr(2, div)
        st = list(stages)[:4] or [{}]
        self.wr(3, (1 if rle else 0) | (2 if test else 0) | ((len(st) - 1) << 2))
        self.wr(4, 0x8000 if post >= RING else max(1, int(post)))
        for s, g in enumerate(st):
            self.wr(10 + 4 * s, (g.get('mask', 0) & 0xFFFF) | ((g.get('value', 0) & 0xFFFF) << 16))
            self.wr(11 + 4 * s, (g.get('rise', 0) & 0xFFFF) | ((g.get('fall', 0) & 0xFFFF) << 16))
            self.wr(12 + 4 * s, g.get('count', 0) & 0xFFFF)
        self.wr(0, 1)                                     # arm
        if not stages:
            self.wr(0, 4)                                 # no trigger set: capture right away

    def set_map(self, m):
        """Channel map: 16 header pin indices (0..35, see PIN_NAMES)."""
        m = [max(0, min(35, int(x))) for x in list(m)[:16]]
        m += DEFAULT_MAP[len(m):]
        for c, p in enumerate(m):
            self.wr(40 + c, p)
        return m

    def get_map(self):
        return [self.rd(40 + c) & 63 for c in range(16)]

    def raw_pins(self):
        """All 36 header pins now (bit i = PIN_NAMES[i])."""
        return self.rd(57) | (self.rd(56) & 15) << 32

    def force(self):
        self.wr(0, 4)

    def stop(self):
        self.wr(0, 2)

    def read(self):
        """The capture as runs: (values, counts, trigger sample index, rle)."""
        rle = bool(self.rd(1) & 8)
        filled, wp, trig_at = min(self.rd(7), RING), self.rd(6), self.rd(5)
        start = (wp - filled) % RING
        trig_half = 0 if rle else trig_at & 1
        trig_at = trig_at if rle else trig_at >> 1
        self.wr(30, start)
        words = self.wnp[self.popv[:filled]].copy()
        trig_word = (trig_at - start) % RING if self.rd(1) & 2 else None
        lo, hi = (words & 0xFFFF).astype(np.uint16), (words >> 16).astype(np.uint16)
        if rle:
            values, counts = lo, hi.astype(np.int64) + 1
            trig = int(counts[:trig_word].sum()) if trig_word is not None else None
        else:
            values = np.empty(2 * filled, np.uint16)
            values[0::2], values[1::2] = lo, hi
            counts = np.ones(len(values), np.int64)
            trig = 2 * trig_word + trig_half if trig_word is not None else None
        # merge equal neighbours: a compact run list for the page (one entry per change)
        if len(values):
            keep = np.ones(len(values), bool)
            keep[1:] = values[1:] != values[:-1]
            idx = np.flatnonzero(keep)
            counts = np.add.reduceat(counts, idx)
            values = values[idx]
        return values, counts, trig, rle


def to_vcd(values, counts, rate_hz, names, trig=None):
    """A VCD file (PulseView, GTKWave) from runs."""
    ts = 1e9 / rate_hz
    out = ['$date %s $end' % time.strftime('%Y-%m-%d %H:%M:%S'), '$version ORPHAN LOGIC LAB SPEKTOR 3000 $end',
           '$timescale 1 ns $end', '$scope module spektor $end']
    ids = [chr(33 + i) for i in range(16)]
    for i in range(16):
        out.append('$var wire 1 %s %s $end' % (ids[i], names[i] if i < len(names) else 'CH%d' % i))
    out += ['$upscope $end', '$enddefinitions $end']
    t, prev = 0, None
    for v, c in zip(values.tolist(), counts.tolist()):
        line = ['#%d' % round(t * ts)]
        for i in range(16):
            b = (v >> i) & 1
            if prev is None or ((prev >> i) & 1) != b:
                line.append('%d%s' % (b, ids[i]))
        out.append(' '.join(line))
        prev, t = v, t + c
    out.append('#%d' % round(t * ts))
    return '\n'.join(out) + '\n'
