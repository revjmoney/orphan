# L3+ voltage step tool for the hashr FPGA I2C master (slot 1, reg 3): read (55 AA 18) or set (55 AA 10 b) the PIC's
# stored voltage byte. usage: picvolt.py <J number> [byte]   (no byte: read only)
import mmap, os, struct, sys, time

fd = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
m = mmap.mmap(fd, 0x1000, offset=0x43C01000)
R = 3 * 4
START, W, RNACK, STOP = 0, 1 << 8, 3 << 8, 1 << 10


def op(w):
    m[R:R + 4] = struct.pack('<I', w)
    end = time.time() + 0.05
    while True:
        st = struct.unpack('<I', m[R:R + 4])[0]
        if not st >> 31:
            return st
        if time.time() > end:
            raise SystemExit('bus stuck')
        time.sleep(0.0002)


def write(a, data):
    st = op(START | (a << 1))
    if st & 0x100:
        op(RNACK | STOP)
        return False
    for i, b in enumerate(data):
        st = op(W | b | (STOP if i == len(data) - 1 else 0))
        time.sleep(0.002)
        if st & 0x100:
            return False
    return True


def read1(a):
    st = op(START | (a << 1) | 1)
    if st & 0x100:
        op(RNACK | STOP)
        return None
    return op(RNACK | STOP) & 0xFF


def resync(a):
    op(START | (a << 1) | STOP)
    time.sleep(0.003)
    read1(a)
    time.sleep(0.003)


def stored(a):
    resync(a)
    write(a, [0x55, 0xAA, 0x18])
    time.sleep(0.003)
    return read1(a)


j = int(sys.argv[1])
a = 0x50 + j - 1
before = stored(a)
if len(sys.argv) > 2:
    b = int(sys.argv[2])
    if not 0 <= b <= 255:
        raise SystemExit('byte 0..255')
    resync(a)
    write(a, [0x55, 0xAA, 0x10, b])
    time.sleep(0.15)
print('J%d stored byte before %s, now %s' % (j, before, stored(a)))
