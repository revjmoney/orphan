# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""Play a video on the ORPHAN Remote (CYD) with ffmpeg.

  py -3 tools/cyd_video.py <cyd ip> <video file> [--size 160x120] [--via <board ip>] [--sound] [--rate 1600000]

ffmpeg first converts the video to small pictures with a 256-colour palette made from the video itself (a light
ordered dither), into a temporary .pal8 file; then the pictures go to the CYD at the video's own speed with the
game stream (UDP 8093), shown 1.5x and centred. A picture that is late is skipped, rows the CYD missed go again.
  --size   160x120 (default, 240 x 180 on the CYD, smoothest) or 212x160 (318 x 240, full screen, more data)
  --via    send from an Orphan board (wired network, the ORPHAN games' cydlink.py there) instead of this PC
  --sound  play the sound on this PC (ffplay) while it plays
Stop any Orphan game that streams to the same CYD first (ardzy stop on that board), they would take turns.
by JMSCNC, makers of RotatoCAM.
"""
import argparse
import os
import subprocess
import sys
import tempfile
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '..', 'games', 'shared'))
import cydlink  # noqa: E402


def convert(video, w, h, out):
    """video -> out: per picture w*h palette indices + 256 x BGRA palette (ffmpeg pal8). Returns pictures/s."""
    fps = subprocess.run(['ffprobe', '-v', 'error', '-select_streams', 'v:0', '-show_entries', 'stream=avg_frame_rate',
                          '-of', 'csv=p=0', video], capture_output=True, text=True).stdout.strip() or '25/1'
    num, den = (fps.split('/') + ['1'])[:2]
    fg = ('scale=%d:%d:force_original_aspect_ratio=decrease,pad=%d:%d:(ow-iw)/2:(oh-ih)/2,split[a][b];'
          '[a]palettegen=max_colors=256:stats_mode=full[p];[b][p]paletteuse=dither=bayer:bayer_scale=5' % (w, h, w, h))
    subprocess.run(['ffmpeg', '-loglevel', 'error', '-y', '-i', video, '-filter_complex', fg, '-an',
                    '-f', 'rawvideo', '-pix_fmt', 'pal8', out], check=True)
    return float(num) / float(den or 1)


def play(path, cyd, w, h, fps, rate):
    """Send the pictures of a .pal8 file at fps (same code runs on a board with --via)."""
    fs = w * h + 1024
    data = open(path, 'rb').read()
    n = len(data) // fs
    link = cydlink.CydLinkUdp(cyd, rate=rate)
    x, y = (320 - w * 3 // 2) // 2, (240 - h * 3 // 2) // 2
    t0, sent = time.perf_counter(), 0
    for i in range(n):
        due = t0 + i / fps
        if time.perf_counter() > due + 1 / fps:          # behind: skip this picture
            continue
        while time.perf_counter() < due:
            time.sleep(0.001)
        f = data[i * fs:(i + 1) * fs]
        img = np.frombuffer(f, np.uint8, w * h).reshape(h, w)
        bgra = np.frombuffer(f, np.uint8, 1024, w * h).reshape(256, 4).astype(np.uint16)
        pal = ((bgra[:, 2] >> 3) << 11) | ((bgra[:, 1] >> 2) << 5) | (bgra[:, 0] >> 3)
        link.send(img, scale=1, x=x, y=y, palette=pal)
        sent += 1
    el = time.perf_counter() - t0
    print('%d of %d pictures in %.1f s = %.1f pictures/s (video %.1f), rows resent for %d lost packets'
          % (sent, n, el, sent / el, fps, link.lost), flush=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('cyd')
    ap.add_argument('video')
    ap.add_argument('--size', default='160x120')
    ap.add_argument('--via')
    ap.add_argument('--sound', action='store_true')
    ap.add_argument('--rate', type=int, default=1600000, help='sending pace, bytes per second (1.6 MB/s was best)')
    ap.add_argument('--play', nargs=4, metavar=('PAL8', 'W', 'H', 'FPS'), help=argparse.SUPPRESS)  # (on a board)
    a = ap.parse_args()
    if a.play:
        play(a.play[0], a.cyd, int(a.play[1]), int(a.play[2]), float(a.play[3]), a.rate)
        return
    w, h = (int(v) for v in a.size.lower().split('x'))
    if w > 212 or h > 160 or w % 2 or h % 2:
        sys.exit('size: even numbers, at most 212x160')
    out = os.path.join(tempfile.gettempdir(), 'cyd_video_%dx%d.pal8' % (w, h))
    print('converting %s to %dx%d ...' % (os.path.basename(a.video), w, h), flush=True)
    fps = convert(a.video, w, h, out)
    snd = None
    if a.via:
        board = 'root@' + a.via
        lib = os.path.join(HERE, '..', '..', 'games', 'shared')
        subprocess.run(['ssh', board, 'mkdir -p /tmp/cyd_video'], check=True)
        subprocess.run(['scp', '-q', out, __file__, os.path.join(lib, 'cydlink.py'), os.path.join(lib, 'cydfast.c'),
                        board + ':/tmp/cyd_video/'], check=True)
        cmd = ('cd /tmp/cyd_video && python3 cyd_video.py %s x --rate %d --play %s %d %d %f'
               % (a.cyd, a.rate, os.path.basename(out), w, h, fps))
        if a.sound:
            snd = subprocess.Popen(['ffplay', '-loglevel', 'error', '-nodisp', '-autoexit', '-vn', a.video])
        subprocess.run(['ssh', board, cmd])
    else:
        if a.sound:
            snd = subprocess.Popen(['ffplay', '-loglevel', 'error', '-nodisp', '-autoexit', '-vn', a.video])
        play(out, a.cyd, w, h, fps, a.rate)
    if snd:
        snd.terminate()


if __name__ == '__main__':
    main()
