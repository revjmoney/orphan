"""iNES ROM -> what the Orphan NES block needs: mapper flags (exactly like fpganes's GameLoader) and the cart.
Two cores:
  NES2 (cart in the DDR): PRG and CHR ROM up to 1 MB each, every mapper fpganes's MultiMapper has (MAPPERS).
       ddr_image() lays the cart out as the FPGA reads it: PRG at 0, CHR at 0x100000.
  NES1 (the older block RAM cart): PRG up to 64 KB, CHR up to 32 KB, uploaded as 32-bit words (words()).
    py -3 nesrom.py game.nes out_prefix        -> out_prefix_prg.hex, out_prefix_chr.hex (NES1), prints the flags
    py -3 nesrom.py --ddr game.nes out.hex     -> the 2 MB DDR image as 64-bit words (for games/sim/tb_nes_ddr.v)
by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later."""
import struct
import sys

PRG_MAX, CHR_MAX = 64 * 1024, 32 * 1024          # NES1: the block RAM cart in the old orphan_nes_block.v
DDR_PRG_MAX, DDR_CHR_MAX = 1 << 20, 1 << 20      # NES2: the DDR cart
CHR_OFS, DDR_SIZE = 1 << 20, 2 << 20
# mappers in fpganes's mmu.v MultiMapper (anything else would silently run as mapper 0)
MAPPERS = {0: 'NROM', 1: 'MMC1', 2: 'UxROM', 3: 'CNROM', 4: 'MMC3', 5: 'MMC5', 7: 'AxROM', 9: 'MMC2',
           11: 'Color Dreams', 13: 'CPROM', 15: '100-in-1', 28: 'Action 53', 34: 'BNROM / NINA-001',
           41: 'Caltron 6-in-1', 47: 'MMC3 multicart', 64: 'RAMBO-1', 66: 'GxROM', 68: 'Sunsoft-4',
           69: 'Sunsoft FME-7', 71: 'Camerica', 79: 'NINA-03/06', 105: 'NES-EVENT', 113: 'NINA-03/06 multicart',
           118: 'TxSROM', 119: 'TQROM', 158: 'Tengen 800037', 228: 'Action 52', 232: 'Camerica Quattro',
           234: 'Maxi 15'}


def size_code(n):
    for code, lim in enumerate((1, 2, 4, 8, 16, 32, 64)):
        if n <= lim:
            return code
    return 7


def clean_header(data):
    """Old dumping tools wrote junk ("DiskDude!" etc.) into bytes 7..15: then byte 7's mapper bits are junk too."""
    h = bytearray(data[:16])
    if (h[7] & 0x0C) != 0x08 and any(h[12:16]):     # (an NES 2.0 header uses those bytes for real)
        h[7:16] = bytes(9)
    return bytes(h) + data[16:]


def parse(data, ddr=True):
    """ddr: the cart goes to the DDR (NES2 core); False: the NES1 block RAM limits."""
    if data[:4] != b'NES\x1a':
        raise ValueError('not an iNES file')
    data = clean_header(data)
    if data[6] & 0x04:
        raise ValueError('trainer (512 bytes for $7000) not supported')
    if data[6] & 0x08:
        raise ValueError('four-screen cart (needs 4 KB of name table RAM) not supported')
    prg_n, chr_n = data[4], data[5]
    mapper = (data[6] >> 4) | (data[7] & 0xF0)
    if (data[7] & 0x0C) == 0x08:                     # NES 2.0: more size bits
        prg_n |= (data[9] & 0x0F) << 8
        chr_n |= (data[9] & 0xF0) << 4
    if prg_n == 0:
        raise ValueError('no PRG ROM in the header')
    flags = (mapper | size_code(prg_n) << 8 | size_code(chr_n) << 11 | (data[6] & 1) << 14 | (1 if chr_n == 0 else 0) << 15)
    prg = data[16:16 + prg_n * 16384]
    chr_ = data[16 + prg_n * 16384:16 + prg_n * 16384 + chr_n * 8192]
    if len(prg) < prg_n * 16384 or len(chr_) < chr_n * 8192:
        raise ValueError('file shorter than its header says')
    if mapper not in MAPPERS:
        raise ValueError('mapper %d not in the core' % mapper)
    pmax, cmax = (DDR_PRG_MAX, DDR_CHR_MAX) if ddr else (PRG_MAX, CHR_MAX)
    if len(prg) > pmax or len(chr_) > cmax:
        raise ValueError('cart too big (PRG %d KB, CHR %d KB; the core takes %d + %d KB)' % (
            len(prg) // 1024, len(chr_) // 1024, pmax // 1024, cmax // 1024))
    if len(prg) == 16384:                       # NROM-128: the 16 KB appears twice ($8000 and $C000)
        prg = prg + prg
    return {'flags': flags, 'mapper': mapper, 'prg': prg, 'chr': chr_, 'prg_kb': prg_n * 16, 'chr_kb': chr_n * 8}


def _pow2(b, unit, code):
    """Repeat b up to the size the mapper's address mask covers (the mask assumes a power of two)."""
    n = unit << code
    if not b:
        return b
    return (b * (-(-n // len(b))))[:max(n, len(b))]


def ddr_image(cart):
    """The 2 MB the FPGA reads: PRG at 0, CHR ROM at 0x100000 (nothing there for a CHR RAM cart)."""
    f = cart['flags']
    prg = _pow2(cart['prg'], 16384, f >> 8 & 7)
    chr_ = _pow2(cart['chr'], 8192, f >> 11 & 7)
    img = bytearray(DDR_SIZE)
    img[:len(prg)] = prg[:DDR_PRG_MAX]
    img[CHR_OFS:CHR_OFS + len(chr_)] = chr_[:DDR_CHR_MAX]
    return img


def words(b):
    b = b + b'\0' * (-len(b) % 4)
    return list(struct.unpack('<%dI' % (len(b) // 4), b))


if __name__ == '__main__':
    if sys.argv[1] == '--ddr':
        r = parse(open(sys.argv[2], 'rb').read())
        img = ddr_image(r)
        with open(sys.argv[3], 'w') as f:
            f.write('\n'.join('%016x' % w for w in struct.unpack('<%dQ' % (len(img) // 8), img)) + '\n')
    else:
        r = parse(open(sys.argv[1], 'rb').read(), ddr=False)
        for name in ('prg', 'chr'):
            with open('%s_%s.hex' % (sys.argv[2], name), 'w') as f:
                f.write('\n'.join('%08x' % w for w in words(r[name])) + '\n')
    print('flags %08x mapper %d (%s) prg %d KB chr %d KB' % (
        r['flags'], r['mapper'], MAPPERS[r['mapper']], r['prg_kb'], r['chr_kb']))
