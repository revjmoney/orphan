#!/usr/bin/env python3
"""MIMIK I2C engine simulation test: Ardzy's I2C master (the one the board self-test uses) talks to the MIMIK
target in Icarus Verilog; a Python model of a real 24Cxx says what every byte must be.
   py -3 test_i2c.py          (needs Icarus Verilog on the PATH, or IVERILOG_BIN = its bin folder)
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..', '..'))
ARDZY_I2C = os.path.join(ROOT, 'ardzy', 'pc_app', 'fpga', 'hdl', 'ardzy_i2c.v')
T, M = 1, 2                       # slots: MIMIK target, Ardzy master
START, STOP, WRITE, READ_ACK, READ_NACK = 1, 2, 3, 4, 5

prog, expect = [], []             # script words; the reads with what they must return (name, mask, value)


def wr(slot, i, v):
    prog.extend([(1 << 28) | (slot << 12) | (i * 4), v & 0xFFFFFFFF])


def rd(slot, i, name, value=None, mask=0xFFFFFFFF):
    prog.extend([(2 << 28) | (slot << 12) | (i * 4), 0])
    expect.append((name, mask, value))


def wait_idle():
    prog.extend([3 << 28, 0])


def wait(n):
    prog.extend([4 << 28, n])


def i2c(cmds, name, expect_bytes):
    """Queue a transaction (<= 16 commands), wait, then check every result: ACK bits for writes, data for reads."""
    for c, d in cmds:
        wr(M, 0, (c << 8) | (d & 0xFF))
    wait_idle()
    k = 0
    for c, d in cmds:
        if c == WRITE:
            want = expect_bytes[k]
            rd(M, 1, '%s: write %02x %s' % (name, d, 'ACK' if want else 'NACK'), (1 << 31) | (want << 8),
               (1 << 31) | (1 << 8))
            k += 1
        elif c in (READ_ACK, READ_NACK):
            want = expect_bytes[k]
            rd(M, 1, '%s: read' % name, (1 << 31) | (1 << 9) | want, (1 << 31) | (1 << 9) | 0xFF)
            k += 1


class Eeprom:
    """What a real 24Cxx does."""
    def __init__(self, size, page, dev=0x50, devmask=0x7F, ab2=False):
        self.mem = bytearray(32768)
        self.size, self.page, self.dev, self.devmask, self.ab2 = size, page, dev, devmask, ab2
        self.ptr = 0
        self.wp = False

    def acks(self, a):
        return (a & self.devmask) == (self.dev & self.devmask)

    def write(self, a, data):
        blk = 0 if self.ab2 else ((a & ~self.devmask & 0x7F) << 8)
        if self.ab2:
            self.ptr = ((data[0] << 8) | data[1]) & self.size
            data = data[2:]
        else:
            self.ptr = (blk | data[0]) & self.size
            data = data[1:]
        for b in data:
            if not self.wp:
                self.mem[self.ptr] = b
            self.ptr = (self.ptr & ~self.page) | ((self.ptr + 1) & self.page)

    def read(self, n):
        out = []
        for _ in range(n):
            out.append(self.mem[self.ptr])
            self.ptr = (self.ptr + 1) & self.size
        return out


def config(e, en=True, wp=False, twr=0):
    wr(T, 0, int(en) | int(wp) << 1 | int(e.ab2) << 2 | e.dev << 8 | e.devmask << 16)
    wr(T, 1, e.size)
    wr(T, 2, e.page)
    wr(T, 3, twr)
    e.wp = wp


def tx_write(e, a, data, name):
    cmds = [(START, 0), (WRITE, a << 1)] + [(WRITE, b) for b in data] + [(STOP, 0)]
    ok = e.acks(a)
    i2c(cmds, name, [ok] + [ok] * len(data) if ok else [0] + [0] * len(data))
    if ok:
        e.write(a, list(data))


def tx_read(e, a, n, name, set_ptr=None):
    cmds = [(START, 0)]
    acks = []
    if set_ptr is not None:
        cmds += [(WRITE, a << 1)] + [(WRITE, b) for b in set_ptr] + [(START, 0)]
        acks += [1] * (1 + len(set_ptr))
        e.write(a, list(set_ptr))
    cmds += [(WRITE, (a << 1) | 1)] + [(READ_ACK, 0)] * (n - 1) + [(READ_NACK, 0), (STOP, 0)]
    i2c(cmds, name, acks + [1] + e.read(n))


def arm_load(e, addr, data):
    wr(T, 8, addr)
    for b in data:
        wr(T, 9, b)
        e.mem[addr] = b
        addr += 1


def arm_check(e, addr, n, name):
    wr(T, 8, addr)
    wait(8)
    for k in range(n):
        rd(T, 9, '%s: image[%03x]' % (name, addr + k), e.mem[addr + k], 0xFF)
        wait(8)


def build():
    wr(M, 3, 9)                                       # SCL = 100 MHz / 40 = 2.5 MHz: fast to simulate
    rd(T, 127, 'ID', int.from_bytes(b'MMK1', 'big'))
    # 24C02: 256 bytes, 8-byte pages
    e = Eeprom(255, 7)
    config(e)
    arm_load(e, 0, [0x10 + k for k in range(16)])
    arm_check(e, 0, 4, 'ARM image load')
    tx_read(e, 0x50, 4, '24C02 random read from 03', set_ptr=[0x03])
    tx_write(e, 0x50, [0x06, 0xA1, 0xB2, 0xC3, 0xD4], '24C02 page write at 06 (wraps to 00)')
    arm_check(e, 0, 8, 'page wrap')
    tx_read(e, 0x50, 2, '24C02 current-address read')
    tx_read(e, 0x50, 5, '24C02 sequential read from FD (rolls over)', set_ptr=[0xFD])
    tx_write(e, 0x51, [0x00, 0x55], 'wrong address 51 gets NACK')
    rd(T, 7, 'COUNTS', (4 << 16) | 11)
    # the event log: first events of the session
    rd(T, 6, 'event 1 addressed 50', (1 << 31) | (1 << 28) | (0x50 << 8), 0xF0FFFF00 | 0xFF)
    rd(T, 6, 'event 2 pointer set 03', (1 << 31) | (2 << 28) | (0x03 << 8) | 0x03, 0xF07FFFFF)
    # write protect
    config(e, wp=True)
    tx_write(e, 0x50, [0x20, 0xEE, 0xEE], 'WP on: ACKed, not stored')
    arm_check(e, 0x20, 2, 'WP kept the image')
    # write cycle: no answer for TWR microseconds after a write, like a real EEPROM (ACK polling)
    config(e, twr=20)
    tx_write(e, 0x50, [0x30, 0x77], 'TWR write')
    i2c([(START, 0), (WRITE, 0xA0), (STOP, 0)], 'during the write cycle: NACK', [0])
    wait(2500)
    i2c([(START, 0), (WRITE, 0xA0), (STOP, 0)], 'after the write cycle: ACK', [1])
    # 24C16: 2 KB, the block number in the device address (0x50..0x57), 16-byte pages
    e16 = Eeprom(2047, 15, 0x50, 0x78)
    e16.mem = e.mem
    config(e16)
    tx_write(e16, 0x53, [0x10, 0x9A, 0x9B], '24C16 block 3 write')
    arm_check(e16, 0x310, 2, '24C16 block 3 lands at 310')
    tx_read(e16, 0x53, 2, '24C16 block 3 read', set_ptr=[0x10])
    # 24C32: 4 KB, two address bytes, 32-byte pages
    e32 = Eeprom(4095, 31, 0x50, 0x7F, ab2=True)
    e32.mem = e.mem
    config(e32)
    tx_write(e32, 0x50, [0x0A, 0xBC, 0x42, 0x43], '24C32 two-byte address write')
    arm_check(e32, 0xABC, 2, '24C32 lands at ABC')
    tx_read(e32, 0x50, 3, '24C32 read', set_ptr=[0x0A, 0xBC])
    # a register chip (LM75 / TMP102 style): 16-bit registers, the pointer stays on its register
    wr(T, 0, 1 | (1 << 3) | (0x48 << 8) | (0x7F << 16))
    wr(T, 1, 255)
    wr(T, 3, 0)
    wr(T, 8, 0)
    for b in (0x19, 0x80, 0x00, 0x00, 0x4B, 0x00, 0x50, 0x00):    # temp 25.5 C, config, THYST 75, TOS 80
        wr(T, 9, b)
    wr(T, 11, (1 << 16) | 0)                         # the temperature register is read-only
    wr(T, 11, (1 << 16) | 1)
    i2c([(START, 0), (WRITE, 0x90), (WRITE, 0x00), (START, 0), (WRITE, 0x91), (READ_ACK, 0), (READ_ACK, 0),
         (READ_ACK, 0), (READ_NACK, 0), (STOP, 0)], 'LM75 temp register read wraps in its 2 bytes',
        [1, 1, 1, 0x19, 0x80, 0x19, 0x80])
    i2c([(START, 0), (WRITE, 0x90), (WRITE, 0x03), (WRITE, 0x55), (WRITE, 0x80), (STOP, 0)], 'LM75 write TOS',
        [1, 1, 1, 1])
    i2c([(START, 0), (WRITE, 0x91), (READ_ACK, 0), (READ_NACK, 0), (STOP, 0)], 'pointer stays on TOS',
        [1, 0x55, 0x80])
    i2c([(START, 0), (WRITE, 0x90), (WRITE, 0x00), (WRITE, 0x11), (WRITE, 0x22), (STOP, 0)],
        'write to read-only temp: ACKed', [1, 1, 1, 1])
    wr(T, 8, 0)
    wait(8)
    rd(T, 9, 'read-only temp kept: byte 0', 0x19, 0xFF)
    wait(8)
    rd(T, 9, 'read-only temp kept: byte 1', 0x80, 0xFF)
    prog.extend([0, 0])


def main():
    build()
    with open(os.path.join(HERE, 'prog.hex'), 'w') as f:
        f.write('\n'.join('%08x' % w for w in prog) + '\n')
    iv = os.environ.get('IVERILOG_BIN', '')                 # Icarus's bin folder, or empty: iverilog on the PATH
    r = subprocess.run([os.path.join(iv, 'iverilog'), '-g2012', '-o', 'tb.vvp', '-s', 'tb_run', '../mimik_i2c.v',
                        '../i2c_slave.v', ARDZY_I2C, 'tb_mimik.v', 'tb_run.v'], cwd=HERE, capture_output=True,
                       text=True)
    if r.returncode:
        print(r.stdout, r.stderr)
        sys.exit(1)
    r = subprocess.run([os.path.join(iv, 'vvp'), '-n', 'tb.vvp'], cwd=HERE, capture_output=True, text=True)
    seq = [int(l.split()[1].replace('x', 'f'), 16) for l in r.stdout.splitlines() if l.startswith('LOG ')]
    done = 'DONE' in r.stdout
    bad = 0
    for k, (name, mask, value) in enumerate(expect):
        got = seq[k] if k < len(seq) else None
        ok = got is not None and (value is None or (got & mask) == (value & mask))
        bad += not ok
        print('%-4s %-48s want %08x got %s' % ('ok' if ok else 'FAIL', name, value & mask,
                                               'none' if got is None else '%08x' % (got & mask)))
    print('script finished: %s; %d checks, %d failed' % (done, len(expect), bad))
    sys.exit(1 if bad or not done else 0)


if __name__ == '__main__':
    main()
