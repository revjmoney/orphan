#!/usr/bin/env python3
"""Orphan login splash: big ANSI title, the JMSCNC monkey, and live board info beside it."""
import importlib.util
import os
import socket

SHARE = '/usr/local/share/orphan'
G, W, C, D, B, R = '\x1b[38;5;214m', '\x1b[97m', '\x1b[96m', '\x1b[38;5;245m', '\x1b[1m', '\x1b[0m'

spec = importlib.util.spec_from_file_location('om', SHARE + '/orphan-menu.py')
om = importlib.util.module_from_spec(spec)
spec.loader.exec_module(om)

try:      # full-color chafa monkey (style 5), else the plain fallback art
    with open(SHARE + '/logo_56.ans', encoding='utf-8') as f:
        logo = [ln + '\x1b[0m' for ln in f.read().rstrip('\n').split('\n')]
    logo_w = 56
except OSError:
    try:
        with open(SHARE + '/logo_big.txt', encoding='utf-8') as f:
            logo = [G + ln for ln in f.read().splitlines()]
    except OSError:
        logo = []
    logo_w = max((len(l) for l in logo), default=0)

cols = os.get_terminal_size().columns if os.isatty(1) else 80
print()
for ln in om.TITLE:
    print(' ' + G + B + ln + R)
print(' ' + W + B + om.TAGLINE + R + '  ' + C + om.BYLINE + R + '  ' + G + B + '[Rev. J. Money - 2026]' + R)
q = om.quote()
if q:
    print(' ' + C + '\x1b[3m' + q + R)
print()

info = [
    '', '', '',
    W + B + 'Welcome to Orphan' + R,
    D + 'the brain of a retired Bitcoin miner' + R,
    '',
    C + 'host    ' + R + socket.gethostname(),
    C + 'address ' + R + om.ip_addr(),
    C + 'running ' + R + om.root_mode(),
    C + 'kernel  ' + R + os.uname().release,
    C + 'chip    ' + R + om.chip_temp() + '  (Zynq-7010, ARM + FPGA)',
    C + 'up      ' + R + om.uptime(),
    '',
    D + 'Dual Cortex-A9 + Artix-7 fabric' + R,
    D + '17,600 LUTs · 80 DSP · 512 MB' + R,
    '',
    G + 'jmscnc.com' + R,
]
width = logo_w
side = cols >= width + 40
for i in range(max(len(logo), len(info))):
    left = logo[i] if i < len(logo) else ' ' * width
    right = info[i] if side and i < len(info) else ''
    print(' ' + left + R + '   ' + right)
if not side:
    for ln in info:
        if ln:
            print(' ' + ln)
print()
