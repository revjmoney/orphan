"""SSTV test signals for orphan-rxd: complex baseband (USB side) at 12207 Hz, int16 I/Q.
   py -3 gen_sstv_tests.py <outdir>  ->  sstv_<mode>.iq + sstv_<mode>_ref.ppm (the picture that was sent)
   Each signal has noise and a 0.05 % clock error, so the decoder's slant tracking has to work."""
import os
import sys

import numpy as np

FS = 12207.03125
CLOCK = 1.0005                                  # sender's clock is 0.05 % off
rng = np.random.default_rng(3)
out = sys.argv[1] if len(sys.argv) > 1 else '.'


def test_image(w, h):
    img = np.zeros((h, w, 3))
    bars = [(255, 255, 255), (255, 255, 0), (0, 255, 255), (0, 255, 0), (255, 0, 255), (255, 0, 0), (0, 0, 255), (0, 0, 0)]
    for i, c in enumerate(bars):
        img[: h // 2, i * w // 8:(i + 1) * w // 8] = c
    img[h // 2:, :] = np.linspace(0, 255, w)[None, :, None]
    yy, xx = np.mgrid[0:h, 0:w]
    img[((xx - w * 0.7) ** 2 + (yy - h * 0.72) ** 2) < (h * 0.15) ** 2] = (255, 80, 0)
    return img


class Tx:
    def __init__(self):
        self.f = []                              # (freq, seconds)

    def tone(self, hz, ms):
        self.f.append((hz, ms / 1000.0 * CLOCK))

    def scan(self, values, ms):                  # values 0..255 -> 1500..2300 Hz over ms
        d = ms / 1000.0 * CLOCK / len(values)
        for v in values:
            self.f.append((1500 + 800 * v / 255.0, d))

    def iq(self):
        total = sum(d for _, d in self.f)
        n = int(total * FS) + 1
        freq = np.zeros(n)
        t = 0.0
        for hz, d in self.f:
            a, b = int(t * FS), int((t + d) * FS)
            freq[a:b] = hz
            t += d
        ph = 2 * np.pi * np.cumsum(freq) / FS
        z = 9000 * np.exp(1j * ph)
        return z + 900 * (rng.standard_normal(n) + 1j * rng.standard_normal(n))


def vis(tx, code):
    tx.tone(1900, 300); tx.tone(1200, 10); tx.tone(1900, 300); tx.tone(1200, 30)
    bits = [(code >> i) & 1 for i in range(7)]
    bits.append(sum(bits) & 1)                   # even parity
    for b in bits:
        tx.tone(1100 if b else 1300, 30)
    tx.tone(1200, 30)


def yuv(rgb):
    R, G, B = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    Y = 0.299 * R + 0.587 * G + 0.114 * B
    return np.clip(Y, 0, 255), np.clip((R - Y) / 1.402 + 128, 0, 255), np.clip((B - Y) / 1.772 + 128, 0, 255)


def save(name, tx, img):
    z = tx.iq()
    a = np.empty(2 * len(z), np.int16)
    a[0::2] = np.clip(z.real, -32767, 32767)
    a[1::2] = np.clip(z.imag, -32767, 32767)
    a.tofile(os.path.join(out, 'sstv_%s.iq' % name))
    with open(os.path.join(out, 'sstv_%s_ref.ppm' % name), 'wb') as f:
        f.write(b'P6\n%d %d\n255\n' % (img.shape[1], img.shape[0]))
        f.write(np.clip(img, 0, 255).astype(np.uint8).tobytes())
    print(name, '%.1f s' % (len(z) / FS))


# Martin M1
img = test_image(320, 256); tx = Tx(); vis(tx, 44)
for y in range(256):
    tx.tone(1200, 4.862); tx.tone(1500, 0.572)
    for c in (1, 2, 0):
        tx.scan(img[y, :, c], 146.432); tx.tone(1500, 0.572)
save('martin1', tx, img)
# Scottie S1
img = test_image(320, 256); tx = Tx(); vis(tx, 60); tx.tone(1200, 9.0)
for y in range(256):
    tx.tone(1500, 1.5); tx.scan(img[y, :, 1], 138.24); tx.tone(1500, 1.5); tx.scan(img[y, :, 2], 138.24)
    tx.tone(1200, 9.0); tx.tone(1500, 1.5); tx.scan(img[y, :, 0], 138.24)
save('scottie1', tx, img)
# Robot 36
img = test_image(320, 240); Y, V, U = yuv(img); tx = Tx(); vis(tx, 8)
for y in range(240):
    tx.tone(1200, 9.0); tx.tone(1500, 3.0); tx.scan(Y[y], 88.0)
    even = y % 2 == 0
    tx.tone(1500 if even else 2300, 4.5); tx.tone(1900, 1.5)
    ch = (V[y] + V[min(y + 1, 239)]) / 2 if even else (U[y] + U[y - 1]) / 2
    tx.scan(ch[::2].repeat(2)[:320][::2], 44.0)
save('robot36', tx, img)
# PD90
img = test_image(320, 256); Y, V, U = yuv(img); tx = Tx(); vis(tx, 99)
for y in range(0, 256, 2):
    tx.tone(1200, 20.0); tx.tone(1500, 2.08)
    tx.scan(Y[y], 170.24); tx.scan((V[y] + V[y + 1]) / 2, 170.24); tx.scan((U[y] + U[y + 1]) / 2, 170.24); tx.scan(Y[y + 1], 170.24)
save('pd90', tx, img)
