#!/usr/bin/env python3
"""MIMIK hardware test on the board: the emulated chip sits on the S9's own I2C bus (real pads W18 / W19 with the
board's 1 kohm pull-ups) and Ardzy's I2C master on the same bus talks to it like any MCU would. Every byte is
compared with what a real 24Cxx would do.
   python3 hw_test.py            (with orphan_mimik loaded: ardzy load orphan_mimik)
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import os
import random
import sys
import time

from mimik_hw import Mimik

m = Mimik()
fails = []


def check(name, ok, info=''):
    print('%-4s %s %s' % ('ok' if ok else 'FAIL', name, info), flush=True)
    if not ok:
        fails.append(name)


rnd = random.Random(int(sys.argv[1]) if len(sys.argv) > 1 else 1)

# 24C02 at three bus speeds
m.load_model('24c02', write_cycle_us=0)
img = bytes(rnd.randrange(256) for _ in range(256))
m.write_image(img)
check('ARM image write / read back (256 bytes)', m.read_image(256) == img)
check('bus scan finds only the emulated chip at 0x50', m.m_scan() == [0x50], str([hex(a) for a in m.m_scan()]))
for khz in (100, 400, 1000):
    t = time.time()
    got = m.m_read(0x50, 0, 256, khz)
    check('I2C read of all 256 bytes at %d kHz' % khz, got == img, '(%.2f s)' % (time.time() - t))

# page writes: the pointer wraps inside the 8-byte page like the real chip
m.clear_counts()
ok = m.m_write(0x50, 0x0E, [0xA1, 0xB2, 0xC3, 0xD4], 400)
want = bytearray(img)
want[0x0E], want[0x0F], want[0x08], want[0x09] = 0xA1, 0xB2, 0xC3, 0xD4
check('page write at 0E wraps to 08 (ACKed)', ok and m.read_image(256) == want)
check('the bus reads back the page write', m.m_read(0x50, 0x08, 8, 400) == bytes(want[8:16]))
s = m.status()
check('counters: 4 bytes written, 8 read', s['writes'] == 4 and s['reads'] == 8, '(%d written, %d read)' %
      (s['writes'], s['reads']))

# random writes over the whole chip, then a full compare
for _ in range(40):
    p = rnd.randrange(256)
    n = rnd.randint(1, 8 - (p & 7))                      # inside one page
    d = [rnd.randrange(256) for _ in range(n)]
    m.m_write(0x50, p, d, 400)
    want[p:p + n] = bytes(d)
check('40 random page writes, full compare (image and bus)', m.read_image(256) == want and
      m.m_read(0x50, 0, 256, 1000) == bytes(want))

# wrong address, write protect, write cycle ACK polling
check('address 0x51 is not answered', not m.m_write(0x51, 0, [1], 100))
m.set_wp(True)
m.m_write(0x50, 0x20, [0x00, 0x11], 100)
check('WP: write ACKed but not stored', m.read_image(2, 0x20) == bytes(want[0x20:0x22]))
m.set_wp(False)
m.wr(3, 5000)                                            # 5 ms write cycle, like the datasheet
m.m_write(0x50, 0x40, [0x5A], 400)
t0 = time.time()
polls = 0
while not m.m_write(0x50, 0x40, [], 400) and time.time() - t0 < 0.1:   # ACK polling, like Linux's at24 driver
    polls += 1
dt = (time.time() - t0) * 1000
check('write cycle: NACKed while programming, then ACK', polls > 0 and 3 < dt < 20, '(%d polls, %.1f ms)' % (polls, dt))
m.wr(3, 0)
want[0x40] = 0x5A

# the live event log
m.events()                                                # drop the old ones
m.m_read(0x50, 0x10, 2, 400)
ev = m.events()
kinds = [e['kind'] for e in ev]
check('event log of a random read: ADDR PTR ADDR READ READ', kinds == ['ADDR', 'PTR', 'ADDR', 'READ', 'READ'] and
      ev[1]['addr'] == 0x10 and ev[3]['data'] == want[0x10], str(kinds))

# 24C16: one chip on 0x50..0x57, the address picks the block
m.load_model('24c16', image=bytes(2048), write_cycle_us=0)
check('24C16 answers 0x50..0x57', m.m_scan() == list(range(0x50, 0x58)))
m.m_write(0x55, 0x33, [0xC0, 0xDE], 400)
check('24C16 block 5 byte 33 lands at image 533', m.read_image(2, 0x533) == b'\xc0\xde')

# 24C256: two address bytes, the whole 32 KB image
m.load_model('24c256', image=bytes(32768), write_cycle_us=0)
big = bytes(rnd.randrange(256) for _ in range(32768))
t = time.time()
m.write_image(big)
check('24C256 image load 32 KB', m.read_image(32768) == big, '(%.1f s load + read)' % (time.time() - t))
check('24C256 bus read at the top (7FF0..7FFF)', m.m_read(0x50, 0x7FF0, 16, 1000, 2) == big[0x7FF0:])
m.m_write(0x50, 0x7FFC, [1, 2, 3, 4, 5, 6], 400, 2)       # 64-byte page: wraps 7FFF -> 7FC0
check('24C256 page wrap at the top of the chip', m.read_image(4, 0x7FFC) == b'\x01\x02\x03\x04' and
      m.read_image(2, 0x7FC0) == b'\x05\x06')

m.load_model('24c02', image=bytes(range(256)), write_cycle_us=0)
r = m.i2c([(1, 0), (3, 0xA1), (5, 0), (2, 0)])          # current-address read right after a model change
check('a new model starts its pointer at 0 (current-address read)', r == [('w', True), ('r', 0)], str(r))
m.load_model('24c02')
print('\n%d failed' % len(fails) + (': ' + ', '.join(fails) if fails else ''))
sys.exit(1 if fails else 0)
