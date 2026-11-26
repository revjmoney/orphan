# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""Play a video on the ORPHAN Remote (CYD) with ffmpeg.

  py -3 tools/cyd_video.py <cyd ip> <video file> [--sound]     --sound: the sound plays on this PC (ffplay)

ffmpeg turns the video into 212 x 160 pictures at its own speed; each one is dithered to a fixed 252-colour palette and sent with the game stream (UDP 8093), shown 1.5x (318 x 240) on the CYD.
Stop any Orphan game that is streaming to the same CYD first (they would take turns). Ctrl+C stops.
by JMSCNC, makers of RotatoCAM.
"""
import argparse
import os
import subprocess
import sys
import threading
import time

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'games', 'shared'))
import cydlink  # noqa: E402

W, H = 212, 160                                    # 1.5x on the CYD = 318 x 240
LEVELS = (6, 7, 6)                                 # 252 colours: 6 red x 7 green x 6 blue


def palette():
    r, g, b = np.meshgrid(*[np.linspace(0, 255, n) for n in LEVELS], indexing='ij')
    r, g, b = (x.reshape(-1).round().astype(np.uint16) for x in (r, g, b))
    return ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)


BAYER = (np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]) + 0.5) / 16 - 0.5
DITHER = np.tile(BAYER, (H // 4, W // 4))[:, :, None]


def quantize(rgb):
    """(H, W, 3) uint8 -> palette indices with ordered dithering."""
    steps = np.array([n - 1 for n in LEVELS], dtype=np.float32)
    q = np.clip(np.floor(rgb.astype(np.float32) * steps / 255 + 0.5 + DITHER), 0, steps).astype(np.uint8)
    return (q[:, :, 0] * (LEVELS[1] * LEVELS[2]) + q[:, :, 1] * LEVELS[2] + q[:, :, 2]).astype(np.uint8)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('cyd')
    ap.add_argument('video')
    ap.add_argument('--sound', action='store_true', help='also play the sound on this PC (ffplay)')
    a = ap.parse_args()
    procs = []
    if a.sound:
        procs.append(subprocess.Popen(['ffplay', '-loglevel', 'error', '-nodisp', '-autoexit', '-vn', a.video]))
    src = ['-re', '-i', a.video]                    # -re: read at the video's own speed
    vf = 'scale=%d:%d:force_original_aspect_ratio=decrease,pad=%d:%d:(ow-iw)/2:(oh-ih)/2' % (W, H, W, H)
    ff = subprocess.Popen(['ffmpeg', '-loglevel', 'error'] + src + ['-vf', vf, '-f', 'rawvideo', '-pix_fmt', 'rgb24',
                          'pipe:1'], stdout=subprocess.PIPE)
    procs.append(ff)
    latest, done = [None], threading.Event()

    def reader():                                   # always keep only the newest picture
        n = W * H * 3
        while True:
            buf = ff.stdout.read(n)
            if len(buf) < n:
                break
            latest[0] = buf
        done.set()
    threading.Thread(target=reader, daemon=True).start()
    link, pal = cydlink.CydLinkUdp(a.cyd), palette()
    n, t0, last = 0, time.time(), None
    try:
        while not done.is_set() or latest[0] is not last:
            buf = latest[0]
            if buf is None or buf is last:
                time.sleep(0.003)
                continue
            last = buf
            img = quantize(np.frombuffer(buf, dtype=np.uint8).reshape(H, W, 3))
            link.send(img, scale=1, x=1, y=0, palette=pal)
            n += 1
            if time.time() - t0 >= 5:
                print('CYD %.1f pictures/s, lost packets %d' % (n / (time.time() - t0), link.lost), flush=True)
                n, t0 = 0, time.time()
    except KeyboardInterrupt:
        pass
    finally:
        for p in procs:
            p.terminate()


if __name__ == '__main__':
    main()
