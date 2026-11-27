"""Game Boy ROM -> what the Orphan Game Boy block needs: the CART register value and the ROM as 32-bit words.
    py -3 gbrom.py game.gb out_prefix      -> out_prefix_rom.hex, prints the CART value
by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later."""
import struct
import sys

ROM_MAX = 128 * 1024                       # the block RAM cart in orphan_gb_block.v
MBC = {0x00: 0, 0x08: 0, 0x09: 0,
       0x01: 1, 0x02: 1, 0x03: 1,
       0x19: 2, 0x1A: 2, 0x1B: 2, 0x1C: 2, 0x1D: 2, 0x1E: 2,
       0x0F: 3, 0x10: 3, 0x11: 3, 0x12: 3, 0x13: 3}
RAM_BANKS = {0: 0, 1: 1, 2: 1, 3: 4, 4: 16, 5: 8}


def parse(data):
    if len(data) < 0x150:
        raise ValueError('not a Game Boy ROM')
    kind, cgb = data[0x147], data[0x143]
    if cgb == 0xC0:
        raise ValueError('Game Boy Color only')
    if kind not in MBC:
        raise ValueError('cartridge type 0x%02X is not supported' % kind)
    if len(data) > ROM_MAX:
        raise ValueError('ROM too big for the block RAM cart (%d KB, max 128)' % (len(data) // 1024))
    banks = max(2, (len(data) + 16383) // 16384)
    ram = max(1, min(4, RAM_BANKS.get(data[0x149], 1)))
    cart = MBC[kind] | (banks - 1) << 4 | (ram - 1) << 8
    title = data[0x134:0x144].split(b'\0')[0].decode('ascii', 'replace').strip()
    return {'cart': cart, 'mbc': MBC[kind], 'rom': bytes(data), 'kb': len(data) // 1024, 'title': title}


def words(b):
    b = b + b'\0' * (-len(b) % 4)
    return list(struct.unpack('<%dI' % (len(b) // 4), b))


if __name__ == '__main__':
    r = parse(open(sys.argv[1], 'rb').read())
    with open('%s_rom.hex' % sys.argv[2], 'w') as f:
        f.write('\n'.join('%08x' % w for w in words(r['rom'])) + '\n')
    print('cart %03x mbc %d rom %d KB words %d title %r' % (r['cart'], r['mbc'], r['kb'], len(words(r['rom'])), r['title']))
