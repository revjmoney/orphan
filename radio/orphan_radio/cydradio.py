"""The radio on the ORPHAN Remote (CYD, 320 x 240), nothing but the signal: the frequency and modes as text, the
spectrum trace and the waterfall, edge to edge on black. main.py feeds it (feed_pan / feed_iq) and it pushes the
picture to the CYD named in /etc/orphan/cyd over its rectangle port (TCP 8091, POST /rect, RGB565 high byte first),
four times a second. A CYD showing another board answers 503: this board then waits and asks again.
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import os
import socket
import threading
import time

import numpy as np

import cydfont

W, H = 320, 240
TOP = 52                     # text: frequency line (0..36) and the tuners / level line (36..52)
SPEC = 70                    # spectrum trace rows
WF0 = TOP + SPEC             # the waterfall starts here and runs to the bottom (one text line less with a decoder)
TEXT_H = 14                  # the decoder's line at the bottom


def rgb565(r, g, b):
    return (int(r) >> 3) << 11 | (int(g) >> 2) << 5 | int(b) >> 3


LIME, WHITE, GREY, RED, AMBER = rgb565(210, 255, 81), rgb565(235, 240, 230), rgb565(140, 150, 140), rgb565(255, 70, 60), rgb565(247, 147, 26)
# waterfall colours: black, deep blue, cyan, lime, yellow, white
_stops = [(0, (0, 0, 0)), (.25, (0, 20, 110)), (.5, (0, 170, 200)), (.7, (150, 240, 60)), (.88, (255, 230, 40)), (1, (255, 255, 255))]
_x = np.linspace(0, 1, 256)
_c = np.array([np.interp(_x, [s for s, _ in _stops], [c[k] for _, c in _stops]) for k in range(3)]).T
PALETTE = ((_c[:, 0].astype(np.uint16) >> 3) << 11 | (_c[:, 1].astype(np.uint16) >> 2) << 5 | _c[:, 2].astype(np.uint16) >> 3)


def text(img, x, y, s, font='R10', color=WHITE):
    """Draw s with its top-left at x, y (clipped to the image). Returns the x after the last letter."""
    size, h, asc, w, stride, bits = cydfont.FONTS[font]
    for ch in s:
        g = ord(ch) - 32
        if not 0 <= g < 95:
            g = 31                                     # '?'
        if x + w > img.shape[1]:
            break
        rows = np.frombuffer(bits, np.uint8, h * stride, g * h * stride).reshape(h, stride)
        mask = np.unpackbits(rows, axis=1)[:, :w].astype(bool)
        y0, y1 = max(0, y), min(img.shape[0], y + h)
        if y1 > y0:
            img[y0:y1, x:x + w][mask[y0 - y:y1 - y]] = color
        x += w
    return x


def text_width(s, font):
    return len(s) * cydfont.FONTS[font][3]


class Screen:
    def __init__(self):
        self.img = np.zeros((H, W), np.uint16)
        self.wf = np.zeros((H - WF0, W), np.uint16)    # the waterfall, newest line on top
        self.pan = None                                # (dB per bin, centre Hz, span Hz, time)
        self.lo, self.hi = None, None                  # the colour scale (dB), following the band slowly
        self.lock = threading.Lock()
        self.busy_until = 0.0
        self.sent = 0

    # ---- inputs from main.py
    def feed_pan(self, db, center, span):
        with self.lock:
            self.pan = (np.asarray(db, np.float32).copy(), float(center), float(span), time.time())

    def feed_iq(self, iq, fs, center):
        """No panadapter in this build (or no data): an FFT of the tuned channel's IQ (int16 pairs) instead."""
        now = time.time()
        if self.pan is not None and now - self.pan[3] < 2 or now - getattr(self, 'iq_t', 0) < 0.2:
            return
        self.iq_t = now
        iq = np.asarray(iq, np.float32)
        if len(iq) < 1024:
            return
        z = (iq[-1024:, 0] + 1j * iq[-1024:, 1]) * np.hanning(1024)
        db = 20 * np.log10(np.abs(np.fft.fftshift(np.fft.fft(z))) + 1e-3)
        with self.lock:
            self.pan = (db.astype(np.float32), float(center), float(fs), time.time() - 1.5)   # stays a fallback

    # ---- drawing
    def columns(self, db):
        """dB per bin -> one value per screen column (the strongest bin under each column)."""
        n = len(db)
        edges = (np.arange(W + 1) * n // W).astype(int)
        return np.maximum.reduceat(db, edges[:-1]) if n >= W else np.interp(np.linspace(0, n - 1, W), np.arange(n), db)

    def draw(self, st, meter, dec_text):
        img = self.img
        img[:] = 0
        # line 1: the frequency, big; the demodulator, the input and the decoder at the right
        f = float(st.get('freq', 0))
        x = text(img, 0, 0, '%.3f' % f, 'B30', LIME)
        text(img, x + 4, 15, 'kHz', 'B13', GREY)
        right = [(st.get('demod', '').upper(), 'B19', WHITE)]
        src = {'rc': 'RC', 'antenna': 'WIRE', 'loopback': 'LOOP', 'jumper': 'JUMP'}.get(st.get('mode', ''), st.get('mode', '').upper())
        right.append((src, 'B13', GREY))
        if st.get('decoder', 'off') != 'off':
            right.append((st['decoder'].upper(), 'B13', AMBER))
        xr = W
        for s, fnt, col in reversed(right):
            xr -= text_width(s, fnt) + 6
            text(img, xr, 2 if fnt == 'B19' else 6, s, fnt, col)
        # line 2: the other tuners (only those on) and the level
        parts = ['%s %.1f %s' % ('BCD'[i], s['freq'], s['demod'].upper()) for i, s in enumerate(st.get('slices', [])) if s.get('on')]
        lvl = meter.get('carrier')
        line = '   '.join(parts)
        x = text(img, 0, 38, line, 'R10', GREY)
        if lvl is not None:
            s = 'LVL %d' % lvl
            text(img, W - text_width(s, 'R10'), 38, s, 'R10', WHITE)
        # spectrum + waterfall
        with self.lock:
            pan = self.pan
        bottom = H - (TEXT_H if dec_text else 0)
        if pan is not None:
            db, center, span, _ = pan
            col = self.columns(db)
            lo, hi = np.percentile(col, 15), np.percentile(col, 99.5)
            if self.lo is None:
                self.lo, self.hi = lo, max(hi, lo + 20)
            self.lo += (lo - self.lo) * .1
            self.hi += (max(hi, self.lo + 20) - self.hi) * .1
            v = np.clip((col - self.lo) / (self.hi - self.lo), 0, 1)
            # the trace: a filled dim area under a bright line
            yv = (TOP + SPEC - 1 - v * (SPEC - 2)).astype(int)
            rows = np.arange(TOP, TOP + SPEC)[:, None]
            img[TOP:TOP + SPEC][rows > yv[None, :]] = rgb565(30, 60, 20)
            img[yv, np.arange(W)] = LIME
            # the tuned frequency, a thin red line through the trace (only when it is inside the span)
            fx = int(round((f * 1000 - (center - span / 2)) / span * W))
            if 0 <= fx < W:
                img[TOP:TOP + SPEC, fx] = RED
            self.wf[1:] = self.wf[:-1]
            self.wf[0] = PALETTE[(v * 255).astype(np.uint8)]
            img[WF0:bottom] = self.wf[:bottom - WF0]
        else:
            text(img, 0, TOP + 20, 'no spectrum from the receiver yet', 'R10', GREY)
        if dec_text:
            text(img, 0, H - TEXT_H + 1, dec_text[-(W // 6):], 'R10', AMBER)
        return img

    # ---- sending
    def send(self, host, img):
        body = img.astype('>u2').tobytes()
        head = ('POST /rect?x=0&y=0&w=%d&h=%d&hud=0 HTTP/1.1\r\nHost: %s\r\nContent-Length: %d\r\nConnection: close\r\n\r\n'
                % (W, H, host, len(body))).encode()
        s = socket.create_connection((host, 8091), timeout=3)
        try:
            s.sendall(head + body)
            reply = s.recv(64)
        finally:
            s.close()
        return reply


def cyd_host():
    try:
        return open('/etc/orphan/cyd').read().strip()
    except OSError:
        return ''


SCREEN = Screen()


def run(get_state, get_meter, get_dec_text, period=0.25):
    """Thread body: draw and push every period seconds while a CYD is named and this board is the one it shows."""
    scr = SCREEN
    while True:
        t = time.time()
        host = cyd_host()
        if host and t >= scr.busy_until:
            try:
                img = scr.draw(get_state(), get_meter(), get_dec_text())
                r = scr.send(host, img)
                if b' 503' in r[:16]:
                    scr.busy_until = t + 2               # the CYD shows another board
                else:
                    scr.sent += 1
            except OSError:
                scr.busy_until = t + 3                   # CYD off or unreachable
        time.sleep(max(0.02, period - (time.time() - t)))

