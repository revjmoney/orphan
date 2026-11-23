"""INTERSEKTOR on the board: the UART man-in-the-middle bridge in the FPGA (intersektor.v, slot 2), and the HOLD
rule engine that rewrites byte sequences on their way through.
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import time

from blocks import Bus

SLOT = 2
CLK = 100e6
MODES = ['OFF', 'WIRE', 'RELAY', 'HOLD']
KINDS = {1: 'PASS', 2: 'SWAP', 3: 'DROP', 4: 'HELD', 5: 'FERR', 6: 'OUT', 7: 'LOST'}
BAUDS = [300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 74880, 115200, 230400, 250000,
         460800, 500000, 921600, 1000000, 1500000, 2000000, 3000000]
# direction 0 = A -> B (in on J6.5, out on J7.11), direction 1 = B -> A (in on J7.5, out on J6.11)
DEFAULT_DIRS = [{'mode': 0, 'baud': 115200, 'rx': 20, 'tx': 25}, {'mode': 0, 'baud': 115200, 'rx': 24, 'tx': 21}]


class Intersektor:
    def __init__(self, bus=None):
        self.bus = bus or Bus()
        mm = self.bus.m
        self.w = mm._w
        self.base = (mm._off >> 2) + SLOT * 1024
        if self.rd(127) != 0x494B5431:
            raise RuntimeError('INTERSEKTOR core not found (load the orphan_spektor bitstream)')
        self.ctrl = 0
        self.wr(0, 0)                                     # GO off, TEST off
        for d in range(2):
            self.wr(16 + 8 * d, 0)                        # OFF
        for d in range(2):                                # the swap tables start cleared (all pass)
            for b in range(256):
                self.wr(2, (d << 24) | b)

    def wr(self, i, v):
        self.w[self.base + i] = int(v) & 0xFFFFFFFF

    def rd(self, i):
        return int(self.w[self.base + i])

    # ---- settings
    def set_ctrl(self, go=None, test=None, extra=0):
        if go is not None:
            self.ctrl = (self.ctrl & ~1) | (1 if go else 0)
        if test is not None:
            self.ctrl = (self.ctrl & ~2) | (2 if test else 0)
        self.wr(0, self.ctrl | extra)

    def heartbeat(self):
        self.wr(0, self.ctrl)

    def set_dir(self, d, mode=None, baud=None, rx=None, tx=None):
        b = 16 + 8 * d
        if baud is not None:
            self.wr(b + 1, max(16, min(1048575, round(CLK / float(baud)))))
        if rx is not None or tx is not None:
            p = self.rd(b + 2)
            r = p & 63 if rx is None else int(rx)
            t = (p >> 8) & 63 if tx is None else int(tx)
            self.wr(b + 2, (t << 8) | r)
        if mode is not None:
            self.wr(b, int(mode) & 3)

    def table(self, d, byte, value=None, drop=False):
        """Byte rule for RELAY: value = new byte (None = pass), drop = throw it away."""
        v = (d << 24) | (byte & 0xFF)
        if drop:
            v |= 1 << 17
        elif value is not None:
            v |= (1 << 16) | ((value & 0xFF) << 8)
        self.wr(2, v)

    def clear_table(self, d):
        for b in range(256):
            self.wr(2, (d << 24) | b)

    def inject(self, d, data, timeout=2.0):
        """Queue bytes to send on direction d (RELAY / HOLD). Waits for room in the 512-byte queue."""
        b = 16 + 8 * d + 3
        t = time.time()
        for x in bytes(data):
            while self.rd(b) >= 512:
                if time.time() - t > timeout:
                    return False
                time.sleep(0.001)
            self.wr(b, x)
        return True

    def test_send(self, d, data, timeout=2.0):
        """TEST mode: the built-in test transmitter of direction d sends these bytes (16-byte queue)."""
        b = 16 + 8 * d + 7
        t = time.time()
        for x in bytes(data):
            while self.rd(b) >= 16:
                if time.time() - t > timeout:
                    return False
                time.sleep(0.0005)
            self.wr(b, x)
        return True

    def clear_log(self):
        self.set_ctrl(extra=0x100)

    def clear_counts(self):
        self.set_ctrl(extra=0x200)
        for d in range(2):
            self.wr(16 + 8 * d + 5, 0)

    # ---- reading
    def log(self, limit=4096):
        """The oldest log entries: (kind, dir, byte, byte_sent, time_us)."""
        out = []
        for _ in range(limit):
            v = self.rd(4)
            if not v & 0x80000000:
                break
            out.append(((v >> 28) & 7, (v >> 27) & 1, v & 0xFF, (v >> 8) & 0xFF, self.rd(5)))
        return out

    def status(self):
        s = self.rd(1)
        st = {'go': bool(self.ctrl & 1), 'test': bool(self.ctrl & 2), 'log': s & 0x7FF, 'log_overflow': bool(s >> 16 & 1),
              'conflict': bool(s >> 17 & 1), 'lost_log': self.rd(7), 'dirs': []}
        for d in range(2):
            b = 16 + 8 * d
            m, p, c, e = self.rd(b), self.rd(b + 2), self.rd(b + 4), self.rd(b + 6)
            cpb, minp = self.rd(b + 1), self.rd(b + 5)
            st['dirs'].append({
                'mode': m & 3, 'active': (m >> 4) & 3, 'baud': round(CLK / cpb), 'rx': p & 63, 'tx': (p >> 8) & 63,
                'rx_bytes': c & 0xFFFF, 'tx_bytes': c >> 16, 'ferr': e & 0xFF, 'lost': (e >> 8) & 0xFF,
                'dropped': (e >> 16) & 0xFF, 'swapped': e >> 24, 'queued': self.rd(b + 3),
                'failsafe': bool(s >> (18 + d) & 1), 'tx_busy': bool(s >> (20 + d) & 1),
                'rx_busy': bool(s >> (22 + d) & 1), 'driving': bool(s >> (24 + d) & 1),
                'minp': None if minp >= 0xFFFFF else minp, 'baud_guess': guess_baud(minp)})
        return st


def guess_baud(minp):
    """The nearest standard baud rate to the shortest pulse seen (within 6 %), or None."""
    if not minp or minp >= 0xFFFFF:
        return None
    est = CLK / minp
    best = min(BAUDS, key=lambda b: abs(b - est) / b)
    return best if abs(best - est) / best < 0.06 else round(est)


class RuleEngine:
    """HOLD-mode rewriting for one direction: rules are (find bytes, replace bytes). Bytes stream through; when a
    rule's find sequence starts here it is swapped for its replacement. A partial match waits at most `wait` seconds
    for the rest, then the bytes go out unchanged."""

    def __init__(self, wait=0.03):
        self.rules = []
        self.buf = bytearray()
        self.t = 0.0
        self.wait = wait
        self.hits = 0

    def set_rules(self, rules):
        self.rules = [(bytes(f), bytes(r)) for f, r in rules if f]

    def feed(self, data, now=None):
        self.buf += data
        self.t = time.time() if now is None else now
        return self._run(False)

    def flush_due(self, now=None):
        now = time.time() if now is None else now
        if self.buf and now - self.t >= self.wait:
            return self._run(True)
        return b''

    def _run(self, force):
        out = bytearray()
        while self.buf:
            for f, r in self.rules:
                if self.buf[:len(f)] == f:
                    out += r
                    del self.buf[:len(f)]
                    self.hits += 1
                    break
            else:
                if not force and any(len(f) > len(self.buf) and f.startswith(bytes(self.buf)) for f, _ in self.rules):
                    break                                  # could still become a match: wait for more bytes
                out.append(self.buf[0])
                del self.buf[0]
                force = False
        return bytes(out)
