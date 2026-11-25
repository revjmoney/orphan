# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""Measure the ORPHAN Remote game stream from a PC, with the same encoder the S9 games use (games/shared/cydlink.py).

  py -3 tools/cyd_game_bench.py <cyd ip> [picture.png|jpg ...] [--frames 120] [--shots DIR]

For each console layout (NES 256x240 1:1, SMS 256x192 1:1, Game Boy and Game Gear 160x144 at 1.5x) it sends three
cases: a still picture, a 16x16 sprite moving, and the whole picture scrolling 1 pixel per frame (every row changes,
the worst case). It prints pictures per second and bytes per picture. Pictures are matched to each console's own
palette, so the data is as compressible as the real thing. by JMSCNC, makers of RotatoCAM.
"""
import argparse
import os
import sys
import time

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'games', 'shared'))
import cydlink  # noqa: E402


def rgb_of565(pal):
    p = np.asarray(pal, dtype=np.uint32)
    return np.stack([(p >> 11 & 31) * 255 // 31, (p >> 5 & 63) * 255 // 63, (p & 31) * 255 // 31], axis=1)


def quantize(img, w, h, pal):
    a = np.asarray(img.convert('RGB').resize((w, h), Image.NEAREST), dtype=np.int32)
    ref = rgb_of565(pal).astype(np.int32)
    d = ((a[:, :, None, :] - ref[None, None, :, :]) ** 2).sum(axis=3)
    return d.argmin(axis=2).astype(np.uint8)


def to565(img, w, h):
    a = np.asarray(img.convert('RGB').resize((w, h), Image.NEAREST), dtype=np.uint16)
    return ((a[:, :, 0] >> 3) << 11 | (a[:, :, 1] >> 2) << 5 | (a[:, :, 2] >> 3)).astype(np.uint16)


def run(link, base, frames, case, **kw):
    t0, nbytes = time.time(), 0
    for f in range(frames):
        if case == 'still':
            img = base
        elif case == 'sprite':
            img = base.copy()
            x, y = (f * 3) % (base.shape[1] - 16), (f * 2) % (base.shape[0] - 16)
            img[y:y + 16, x:x + 16] = img.max()
        else:
            img = np.roll(base, f, axis=1)
        nbytes += link.send(img, **kw)
    dt = time.time() - t0
    return frames / dt, nbytes / frames


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('host')
    ap.add_argument('pictures', nargs='*')
    ap.add_argument('--frames', type=int, default=120)
    ap.add_argument('--tcp', action='store_true', help='use the TCP 8092 stream instead of UDP 8093')
    ap.add_argument('--rate', type=int, default=1200000, help='UDP pacing, bytes per second')
    a = ap.parse_args()
    pics = [Image.open(p) for p in a.pictures] or [Image.new('RGB', (256, 240), (40, 80, 160))]
    link = cydlink.CydLink(a.host) if a.tcp else cydlink.CydLinkUdp(a.host, rate=a.rate)
    layouts = [
        ('NES', lambda im: quantize(im, 256, 240, cydlink.RGB565), dict(scale=0, x=32, y=0, palette=cydlink.RGB565)),
        ('SMS', lambda im: quantize(im, 256, 192, cydlink.SMS565), dict(scale=0, x=32, y=24, palette=cydlink.SMS565)),
        ('Game Boy', lambda im: quantize(im.convert('L').convert('RGB'), 160, 144, cydlink.GB565),
         dict(scale=1, x=40, y=12, palette=cydlink.GB565)),
        ('Game Gear', lambda im: to565(im, 160, 144), dict(scale=1, x=40, y=12, palette=None)),
    ]
    print('%-10s %-7s %8s %10s' % ('console', 'case', 'fps', 'bytes/pic'))
    for name, make, kw in layouts:
        for pic in pics:
            base = make(pic)
            for case in ('still', 'sprite', 'scroll'):
                link.prev = None                       # start each case with a full picture
                fps, per = run(link, base, a.frames, case, **kw)
                print('%-10s %-7s %8.1f %10.0f' % (name, case, fps, per), flush=True)
    print('lost packets:', getattr(link, 'lost', 0))
    link.close()


if __name__ == '__main__':
    main()
