"""Synthetic test signals for orphan-rxd's decoders: complex baseband int16 I/Q at 12207 Hz (what the FPGA delivers).
   py -3 gen_decoder_tests.py <outdir>   -> cw.iq, navtex.iq, wwvb.iq"""
import os
import sys

import numpy as np

FS = 12207.03125
rng = np.random.default_rng(7)
out = sys.argv[1] if len(sys.argv) > 1 else '.'


def save(name, z, noise=500.0):
    z = z + noise * (rng.standard_normal(len(z)) + 1j * rng.standard_normal(len(z)))
    a = np.empty(2 * len(z), np.int16)
    a[0::2] = np.clip(z.real, -32767, 32767)
    a[1::2] = np.clip(z.imag, -32767, 32767)
    a.tofile(os.path.join(out, name))
    print(name, '%.1f s' % (len(z) / FS))


# ---------------------------------------------------------------- CW: "CQ CQ DE ORPHAN TEST 73" at 18 wpm, 30 Hz off
MORSE = {'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....', 'I': '..',
         'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
         'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-', 'Y': '-.--', 'Z': '--..',
         '0': '-----', '1': '.----', '2': '..---', '3': '...--', '4': '....-', '5': '.....', '6': '-....',
         '7': '--...', '8': '---..', '9': '----.'}
dot = 1.2 / 18
key = [0.0] * int(0.5 * FS)
for word in 'CQ CQ DE ORPHAN TEST 73'.split():
    for ch in word:
        for s in MORSE[ch]:
            key += [1.0] * int((1 if s == '.' else 3) * dot * FS) + [0.0] * int(dot * FS)
        key += [0.0] * int(2 * dot * FS)
    key += [0.0] * int(4 * dot * FS)
key += [0.0] * int(0.5 * FS)
k = np.convolve(np.array(key), np.hanning(int(0.005 * FS)) / np.hanning(int(0.005 * FS)).sum(), 'same')
t = np.arange(len(k)) / FS
save('cw.iq', 8000 * k * np.exp(2j * np.pi * 30 * t))

# ---------------------------------------------------------------- NAVTEX: CCIR 476 FEC, 100 baud, +-85 Hz (mark = +85)
LTRS = {'J': 0x17, 'F': 0x1B, 'C': 0x1D, 'K': 0x1E, 'W': 0x27, 'Y': 0x2B, 'P': 0x2D, 'Q': 0x2E, 'G': 0x35, 'M': 0x39,
        'X': 0x3A, 'V': 0x3C, 'A': 0x47, 'S': 0x4B, 'I': 0x4D, 'U': 0x4E, 'D': 0x53, 'R': 0x55, 'E': 0x56, 'N': 0x59,
        'Z': 0x63, 'L': 0x65, 'H': 0x69, 'O': 0x71, 'B': 0x72, 'T': 0x74}
FIGS = {'2': 0x27, '6': 0x2B, '0': 0x2D, '1': 0x2E, '.': 0x39, '/': 0x3A, '8': 0x4D, '7': 0x4E, '4': 0x55, '3': 0x56,
        ',': 0x59, '9': 0x71, '?': 0x72, '5': 0x74, '-': 0x47}
C_ALPHA, C_FIGS, C_LTRS, C_SP, C_REP, C_BLK, C_LF, C_CR = 0x0F, 0x36, 0x5A, 0x5C, 0x66, 0x6A, 0x6C, 0x78
text = 'ZCZC AA00\nORPHAN NAVTEX TEST 123 OK\nNNNN'
codes, figs = [C_LTRS], False
for ch in text:
    if ch == '\n':
        codes += [C_CR, C_LF]
    elif ch == ' ':
        codes.append(C_SP)
    elif ch in LTRS:
        if figs:
            codes.append(C_LTRS)
            figs = False
        codes.append(LTRS[ch])
    else:
        if not figs:
            codes.append(C_FIGS)
            figs = True
        codes.append(FIGS[ch])
stream = []
for _ in range(20):                                       # phasing: (rep, alpha) pairs
    stream += [C_REP, C_ALPHA]
for i, c in enumerate(codes):                             # fldigi create_fec: (char i, char i-2 or alpha)
    stream += [c, codes[i - 2] if i >= 2 else C_ALPHA]
for i in range(2):
    stream += [C_BLK, codes[len(codes) - 2 + i]]
for _ in range(6):
    stream += [C_BLK, C_BLK]
bits = []
for c in stream:
    bits += [(c >> k) & 1 for k in range(7)]              # bit 0 first on air
spb = FS / 100
n = int(len(bits) * spb) + int(FS)
idx = np.minimum((np.arange(n) / spb).astype(int), len(bits) - 1)
f = np.where(np.array(bits)[idx] == 1, 85.0, -85.0)
f[: int(0.3 * FS)] = 85.0
ph = 2 * np.pi * np.cumsum(f) / FS
save('navtex.iq', 9000 * np.exp(1j * ph))

# ---------------------------------------------------------------- WWVB: day 325 2026, 14:37 UTC, from second 50
def frame(minute, hour, doy, year):
    b = [0] * 60
    for s in (0, 9, 19, 29, 39, 49, 59):
        b[s] = 2
    def bcd(val, secs, weights):
        for s, w in zip(secs, weights):
            if val >= w:
                b[s] = 1
                val -= w
    bcd(minute, [1, 2, 3, 5, 6, 7, 8], [40, 20, 10, 8, 4, 2, 1])
    bcd(hour, [12, 13, 15, 16, 17, 18], [20, 10, 8, 4, 2, 1])
    bcd(doy, [22, 23, 25, 26, 27, 28, 30, 31, 32, 33], [200, 100, 80, 40, 20, 10, 8, 4, 2, 1])
    bcd(year, [45, 46, 47, 48, 50, 51, 52, 53], [80, 40, 20, 10, 8, 4, 2, 1])
    return b
syms = frame(36, 14, 325, 26)[50:] + frame(37, 14, 325, 26) + [2, 0, 0]
amp = []
for s in syms:
    low = {0: 0.2, 1: 0.5, 2: 0.8}[s]
    amp += [0.14] * int(low * FS) + [1.0] * int((1 - low) * FS)
amp = np.convolve(np.array(amp), np.ones(60) / 60, 'same')
t = np.arange(len(amp)) / FS
save('wwvb.iq', 10000 * amp * np.exp(2j * np.pi * 3 * t), noise=700)
