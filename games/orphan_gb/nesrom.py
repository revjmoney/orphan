"""iNES ROM -> what the Orphan NES block needs: mapper flags (exactly like fpganes's GameLoader) and the cart
bytes as 32-bit little-endian words for PRG (cart address 0x00000) and CHR (0x10000).
    py -3 nesrom.py game.nes out_prefix      -> out_prefix_prg.hex, out_prefix_chr.hex, prints the flags
by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later."""
import struct
import sys

PRG_MAX, CHR_MAX = 64 * 1024, 32 * 1024     # the block RAM cart in orphan_nes_block.v


def size_code(n):
    for code, lim in enumerate((1, 2, 4, 8, 16, 32, 64)):
        if n <= lim:
            return code
    return 7


def parse(data):
    if data[:4] != b'NES\x1a':
        raise ValueError('not an iNES file')
    if data[6] & 0x0C:
        raise ValueError('trainer / four-screen carts are not supported')
    prg_n, chr_n = data[4], data[5]
    mapper = (data[6] >> 4) | (data[7] & 0xF0)
    flags = (mapper | size_code(prg_n) << 8 | size_code(chr_n) << 11 | (data[6] & 1) << 14 | (1 if chr_n == 0 else 0) << 15)
    prg = data[16:16 + prg_n * 16384]
    chr_ = data[16 + prg_n * 16384:16 + prg_n * 16384 + chr_n * 8192]
    if len(prg) > PRG_MAX or len(chr_) > CHR_MAX:
        raise ValueError('cart too big for the block RAM cart (PRG %d KB, CHR %d KB)' % (len(prg) // 1024, len(chr_) // 1024))
    if len(prg) == 16384:                       # NROM-128: the 16 KB appears twice ($8000 and $C000)
        prg = prg + prg
    return {'flags': flags, 'mapper': mapper, 'prg': prg, 'chr': chr_, 'prg_kb': prg_n * 16, 'chr_kb': chr_n * 8}


def words(b):
    b = b + b'\0' * (-len(b) % 4)
    return list(struct.unpack('<%dI' % (len(b) // 4), b))


if __name__ == '__main__':
    r = parse(open(sys.argv[1], 'rb').read())
    for name in ('prg', 'chr'):
        with open('%s_%s.hex' % (sys.argv[2], name), 'w') as f:
            f.write('\n'.join('%08x' % w for w in words(r[name])) + '\n')
    print('flags %08x mapper %d prg %d KB chr %d KB prg words %d chr words %d' % (
        r['flags'], r['mapper'], r['prg_kb'], r['chr_kb'], len(words(r['prg'])), len(words(r['chr']))))
