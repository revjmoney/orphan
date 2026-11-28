"""MIMIK on the board: load a chip model into the FPGA's I2C target engine, fill / read its image, drain the live
event log, and the self-test master (Ardzy's I2C master on the board's own bus, slot 2).
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import importlib.util
import json
import os
import re
import time

from blocks import Bus, require

SLOT, MASTER = 1, 2
IMAGE = 32768
PIN_NAMES = ['J%d.%d' % (n, p) for n in range(1, 10) for p in (5, 11, 12, 15)] + ['I2C SCL', 'I2C SDA']
BOARD_SCL, BOARD_SDA = 36, 37
KINDS = {1: 'ADDR', 2: 'PTR', 3: 'WRITE', 4: 'READ', 5: 'BLOCKED'}
HERE = os.path.dirname(os.path.abspath(__file__))
MODELS = os.path.join(HERE, 'models')


def list_models():
    out = []
    for d in sorted(os.listdir(MODELS)):
        try:
            with open(os.path.join(MODELS, d, 'model.json')) as f:
                m = json.load(f)
            m['id'] = d
            out.append(m)
        except (OSError, ValueError):
            pass
    return out


class Mimik:
    def __init__(self):
        self.bus = Bus()
        require(self.bus, 'MMK1')
        mm = self.bus.m
        self.w = mm._w
        self.base = (mm._off >> 2) + SLOT * 1024
        self.mbase = (mm._off >> 2) + MASTER * 1024
        self.model = None
        self.plugin = None                 # the model's model.py (sensor chips), if it has one
        self.ro_set = set()

    def wr(self, i, v):
        self.w[self.base + i] = int(v) & 0xFFFFFFFF

    def rd(self, i):
        return int(self.w[self.base + i])

    # ---- the chip
    def configure(self, dev, devmask=0x7F, size=256, page=8, addr_bytes=1, wp=False, twr_us=0, enable=True,
                  scl=BOARD_SCL, sda=BOARD_SDA, reg_width=1):
        self.wr(0, 0)                                          # off while it changes
        self.wr(1, max(1, min(IMAGE, size)) - 1)
        self.wr(2, max(1, page) - 1)
        self.wr(3, twr_us)
        self.wr(10, (scl & 63) | (sda & 63) << 8)
        rw = {1: 0, 2: 1, 4: 2}.get(int(reg_width), 0)
        self.wr(0, int(enable) | int(wp) << 1 | int(addr_bytes == 2) << 2 | rw << 3 | (dev & 0x7F) << 8 |
                (devmask & 0x7F) << 16)

    def load_model(self, mid, image=None, **over):
        if not re.fullmatch(r'[A-Za-z0-9_-]{1,64}', str(mid)):      # a folder name in models/, never a path
            raise ValueError('bad model name')
        with open(os.path.join(MODELS, mid, 'model.json')) as f:
            m = json.load(f)
        c = dict(m.get('config', {}))
        c.update(over)
        self.configure(dev=int(str(c.get('address', '0x50')), 0), devmask=int(str(c.get('address_mask', '0x7f')), 0),
                       size=int(c.get('size', 256)), page=int(c.get('page', 8)),
                       addr_bytes=int(c.get('address_bytes', 1)), wp=bool(c.get('wp', False)),
                       twr_us=int(c.get('write_cycle_us', 0)), scl=int(c.get('scl', BOARD_SCL)),
                       sda=int(c.get('sda', BOARD_SDA)), reg_width=int(c.get('register_width', 1)))
        for a in self.ro_set:                                  # the last chip's read-only bytes are writable again
            self.wr(11, a)
        self.ro_set = set()
        if image is None:
            p = os.path.join(MODELS, mid, m.get('image', 'image.bin'))
            image = open(p, 'rb').read() if os.path.isfile(p) else bytes([m.get('fill', 0xFF)]) * int(c.get('size', 256))
        self.write_image(image)
        self.model = dict(m, id=mid, config=c)
        self.plugin = None
        mp = os.path.join(MODELS, mid, 'model.py')
        if os.path.isfile(mp):                                 # a sensor chip: its behaviour on the ARM
            spec = importlib.util.spec_from_file_location('mimik_model_' + mid, mp)
            self.plugin = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(self.plugin)
            if hasattr(self.plugin, 'setup'):
                self.plugin.setup(self)
        return self.model

    # ---- helpers for sensor models (model.py)
    def ro(self, addr, n=1, on=True):
        """Make image bytes read-only for the bus master (its writes are ACKed and dropped, like the real chip)."""
        for a in range(addr, addr + n):
            self.wr(11, a | (int(on) << 16))
            (self.ro_set.add if on else self.ro_set.discard)(a)

    def put(self, addr, data):
        """Write register bytes between bus accesses, so a master never reads half of a new value."""
        t = time.time()
        while self.rd(4) & 1 and time.time() - t < 0.005:      # busy: a transaction is going on
            pass
        self.write_image(bytes(data), addr)

    def get(self, addr, n=1):
        return self.read_image(n, addr)

    def settings(self):
        c, ps = self.rd(0), self.rd(10)
        return {'enable': bool(c & 1), 'wp': bool(c & 2), 'address_bytes': 2 if c & 4 else 1,
                'register_width': (1, 2, 4, 4)[(c >> 3) & 3],
                'address': (c >> 8) & 0x7F, 'address_mask': (c >> 16) & 0x7F, 'size': self.rd(1) + 1,
                'page': self.rd(2) + 1, 'write_cycle_us': self.rd(3), 'scl': ps & 63, 'sda': (ps >> 8) & 63}

    def status(self):
        s, n = self.rd(4), self.rd(7)
        return {'busy': bool(s & 1), 'addressed': bool(s & 2), 'bus_active': bool(s & 4), 'write_cycle': bool(s & 8),
                'bus_address': (s >> 8) & 0x7F, 'events_waiting': s >> 16, 'pointer': self.rd(5),
                'reads': n & 0xFFFF, 'writes': n >> 16}

    def set_wp(self, on):
        c = self.rd(0)
        self.wr(0, (c | 2) if on else (c & ~2))

    def clear_counts(self):
        self.wr(7, 0)

    def write_image(self, data, at=0):
        self.wr(8, at)
        for b in data:
            self.wr(9, b)

    def read_image(self, n, at=0):
        self.wr(8, at)
        out = bytearray(n)
        for k in range(n):
            out[k] = self.rd(9) & 0xFF
        return bytes(out)

    def events(self, most=512):
        out = []
        for _ in range(most):
            e = self.rd(6)
            if not e >> 31:
                break
            k = (e >> 28) & 7
            out.append({'kind': KINDS.get(k, str(k)), 'addr': (e >> 8) & 0x7FFF, 'data': e & 0xFF})
        return out

    # ---- the self-test master on the board's own I2C bus
    def m_wr(self, i, v):
        self.w[self.mbase + i] = int(v) & 0xFFFFFFFF

    def m_rd(self, i):
        return int(self.w[self.mbase + i])

    def i2c(self, cmds, khz=100):
        """Run up to 16 master commands [(cmd, data)]: 1 START 2 STOP 3 WRITE 4 READ+ACK 5 READ+NACK.
        Returns [('w', acked) | ('r', byte)] in order."""
        self.m_wr(3, max(1, round(100e6 / (4 * khz * 1000))) - 1)
        for c, d in cmds:
            self.m_wr(0, (c << 8) | (d & 0xFF))
        t = time.time()
        while self.m_rd(2) & ((1 << 16) | 0x1F):
            if time.time() - t > 1:
                raise TimeoutError('I2C master stuck (status %08x)' % self.m_rd(2))
        out = []
        while True:
            r = self.m_rd(1)
            if not r >> 31:
                return out
            out.append(('r', r & 0xFF) if r & (1 << 9) else ('w', bool(r & (1 << 8))))

    def m_read(self, dev, ptr, n, khz=100, addr_bytes=1):
        """A random read through the board's I2C bus: like any I2C master (i2cget, a CPU) would read the chip."""
        data = []
        while len(data) < n:
            k = min(11 - addr_bytes, n - len(data))     # <= 16 commands in the queue
            p = ptr + len(data)
            pre = [(3, p >> 8)] if addr_bytes == 2 else []
            cmds = [(1, 0), (3, dev << 1)] + pre + [(3, p & 0xFF), (1, 0), (3, dev << 1 | 1)]
            cmds += [(4, 0)] * (k - 1) + [(5, 0), (2, 0)]
            r = self.i2c(cmds, khz)
            if not all(a for t, a in r if t == 'w'):
                raise IOError('no ACK from 0x%02x' % dev)
            data.extend(v for t, v in r if t == 'r')
        return bytes(data)

    def m_write(self, dev, ptr, data, khz=100, addr_bytes=1):
        pre = [(3, ptr >> 8)] if addr_bytes == 2 else []
        r = self.i2c([(1, 0), (3, dev << 1)] + pre + [(3, ptr & 0xFF)] + [(3, b) for b in data] + [(2, 0)], khz)
        return all(a for t, a in r if t == 'w')

    def m_scan(self, khz=100):
        found = []
        for a in range(0x08, 0x78):
            r = self.i2c([(1, 0), (3, a << 1), (2, 0)], khz)
            if r and r[0][1]:
                found.append(a)
        return found
