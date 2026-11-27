"""The NES2 core's cart in the board's DDR (see orphan_nes_block.v): 2 MB of this program's memory, locked so it
never moves or swaps, shared (MAP_SHARED) so a forked process (the CYD sender) can never make it copy-on-write to
new pages. The FPGA finds it through a page table of 512 physical 4 KB pages and reads it over the PS's HP2 port.
The HP ports read the DDR, not the ARM's caches: after copying a cart in, the caches are written back by writing
8 MB elsewhere (the L2 is 512 KB), and a few bytes are read back by the FPGA itself (the probe) to make sure.
Linux only; needs root (mlock, /proc/self/pagemap, /dev/mem).
by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later."""
import ctypes
import mmap
import os
import random
import struct
import time

SIZE = 2 << 20
AFI = (0xF8008000, 0xF8009000, 0xF800A000, 0xF800B000)     # the HP ports' AFI blocks (RDCHAN_CTRL at +0)


def hp_64bit():
    """The S9's boot firmware may leave HP ports in 32-bit mode (RDCHAN_CTRL bit 0, seen on HP0): the upper half of
    every 64-bit word would read 0. Clear it on all four (one 32-bit access each: byte access faults there)."""
    f = os.open('/dev/mem', os.O_RDWR | os.O_SYNC)
    try:
        for base in AFI:
            m = mmap.mmap(f, 4096, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=base)
            r = memoryview(m).cast('I')
            for i in (0, 5):                                # RDCHAN_CTRL, WRCHAN_CTRL
                if r[i] & 1:
                    r[i] = r[i] & ~1
            r.release()
            m.close()
    finally:
        os.close(f)


class CartStore:
    def __init__(self, size=SIZE):
        self.size = size
        self.libc = ctypes.CDLL('libc.so.6', use_errno=True)
        self.buf = mmap.mmap(-1, size, flags=mmap.MAP_SHARED | mmap.MAP_ANONYMOUS)
        self.addr = ctypes.addressof(ctypes.c_char.from_buffer(self.buf))
        try:
            open('/proc/sys/vm/compact_unevictable_allowed', 'w').write('0')     # locked pages stay put
        except OSError:
            pass
        self.buf[:] = bytes(size)                            # every page present
        if self.libc.mlock(ctypes.c_void_p(self.addr), ctypes.c_size_t(size)) != 0:
            raise OSError(ctypes.get_errno(), 'mlock failed (run as root)')
        self.scratch = mmap.mmap(-1, 8 << 20, flags=mmap.MAP_PRIVATE | mmap.MAP_ANONYMOUS)
        self.scratch_addr = ctypes.addressof(ctypes.c_char.from_buffer(self.scratch))
        self.fill = 0

    def pages(self):
        """The physical page of every 4 KB (read again each time: never trust an old table)."""
        with open('/proc/self/pagemap', 'rb') as f:
            f.seek(self.addr // 4096 * 8)
            raw = f.read(self.size // 4096 * 8)
        pages = []
        for (e,) in struct.iter_unpack('<Q', raw):
            pfn = e & ((1 << 55) - 1)
            if not (e >> 63) or pfn == 0 or pfn >= 1 << 20:
                raise RuntimeError('could not read the physical pages (run as root)')
            pages.append(pfn)
        return pages

    def flush(self):
        """Push the ARM's caches out to the DDR: write 8 MB of other memory."""
        self.fill = (self.fill + 1) & 0xFF
        self.libc.memset(ctypes.c_void_p(self.scratch_addr), self.fill, ctypes.c_size_t(8 << 20))

    def load(self, img):
        self.buf[:] = bytes(img)
        self.flush()
        return self.pages()


def load_cart(W, R, store, img, tries=2):
    """Copy img (2 MB, nesrom.ddr_image) to the DDR, write the page table, check it with the probe.
    The console must be held in reset (CTRL 0). Returns '' or what went wrong."""
    hp_64bit()
    for attempt in range(tries):
        pages = store.load(img)
        W(13, 0)
        for p in pages:
            W(14, p)
        bad = probe_check(W, R, img)
        if not bad:
            break
        store.flush()
    else:
        return bad
    t = time.time()
    while not R(18) & 1:                                      # cache tags swept
        if time.time() - t > 0.5:
            return 'cache clear did not finish'
    return ''


def probe(W, R, ofs):
    a = R(15) & 1
    W(15, ofs)
    t = time.time()
    while (R(15) & 1) == a:
        if time.time() - t > 0.1:
            raise TimeoutError('DDR probe got no answer')
    return R(16) | R(17) << 32


def probe_check(W, R, img, n=8):
    """The FPGA reads n spots itself; '' when they all match. Prefers spots that are not zero."""
    spots = [0, 0x100000]
    nz = [i for i in range(0, len(img), 4096) if any(img[i:i + 8])]
    spots += random.sample(nz, min(n - 2, len(nz))) if nz else []
    for ofs in spots:
        try:
            got = probe(W, R, ofs)
        except TimeoutError as e:
            return str(e)
        want = struct.unpack_from('<Q', img, ofs)[0]
        if got != want:
            return 'DDR check failed at cart byte 0x%x: FPGA read %016x, should be %016x' % (ofs, got, want)
    return ''
