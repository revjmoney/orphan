"""Atari 2600 cart -> what the Orphan 2600 block needs: the bank switching scheme (the A2601 core's numbers), the
Superchip flag and the ROM bytes. Detection follows Stella's well known signatures (CartDetector); a file name tag
like "[F8]", "(E0)" or ".F6.bin" picks the scheme by hand.
    py -3 a26rom.py game.bin       -> prints what it found
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os
import re
import sys

ROM_MAX = 32 * 1024                         # the block RAM cart in orphan_a26_block.v
SCHEMES = {'AUTO': 0, 'F8': 1, 'F6': 2, 'FE': 3, 'E0': 4, '3F': 5, 'F4': 6, 'DPC': 7, 'FA': 8, 'CV': 9,
           '2K': 10, 'UA': 11, 'E7': 12, 'F0': 13, '4K': 0}
NAMES = {v: k for k, v in SCHEMES.items() if k not in ('AUTO',)}
NAMES[0] = '4K'


def _has(data, sigs, need=1):
    return sum(data.count(bytes(s)) for s in sigs) >= need


def is_e0(d):
    return _has(d, ([0x8D, 0xE0, 0x1F], [0x8D, 0xE0, 0x5F], [0x8D, 0xE9, 0xFF], [0x0C, 0xE0, 0x1F], [0xAD, 0xE0, 0x1F],
                    [0xAD, 0xE9, 0xFF], [0xAD, 0xED, 0xFF], [0xAD, 0xF3, 0xBF]))


def is_3f(d):
    return d.count(bytes([0x85, 0x3F])) >= 2


def is_fe(d):
    return _has(d, ([0x20, 0x00, 0xD0, 0xC6, 0xC5], [0x20, 0xC3, 0xF8, 0xA5, 0x82], [0xD0, 0xFB, 0x20, 0x73, 0xFE],
                    [0x20, 0x00, 0xF0, 0x84, 0xD6]))


def is_ua(d):
    return _has(d, ([0x8D, 0x40, 0x02], [0xAD, 0x40, 0x02], [0xBD, 0x1F, 0x02], [0x2C, 0xC0, 0x02], [0x8D, 0xC0, 0x02]))


def is_e7(d):
    return _has(d, ([0xAD, 0xE2, 0xFF], [0xAD, 0xE5, 0xFF], [0xAD, 0xE5, 0x1F], [0xAD, 0xE7, 0x1F], [0x0C, 0xE7, 0x1F],
                    [0x8D, 0xE7, 0xFF], [0x8D, 0xE7, 0x1F]))


def is_superchip(d):
    """Superchip carts: the RAM's write port (first 128 bytes of each 4 KB bank) and read port (next 128) were
    dumped as the same bytes, in every bank (Stella's test)."""
    if len(d) < 8192:
        return False
    for b in range(0, len(d), 4096):
        if d[b:b + 128] != d[b + 128:b + 256]:
            return False
    return True


def parse(data, name=''):
    n = len(data)
    if n == 0:
        raise ValueError('empty file')
    tag = re.search(r'[\[(.](F8|F6|F4|FE|E0|E7|3F|FA|UA|F0|DPC|CV|2K|4K)(SC)?[\])._]', os.path.basename(name).upper())
    if n == 10495:                          # Pitfall II with its 255 byte sound ROM dump: drop the extra
        data, n = data[:10240], 10240
    if n > ROM_MAX:
        raise ValueError('cart too big for the block RAM cart (%d KB, 32 KB max)' % (n // 1024))
    sc = False
    if tag:
        bs = SCHEMES[tag.group(1)]
        sc = bool(tag.group(2)) or is_superchip(data)
    elif n <= 2048:
        bs = SCHEMES['2K']
    elif n <= 4096:
        bs = 0
    elif n == 8192:
        bs = (SCHEMES['E0'] if is_e0(data) else SCHEMES['3F'] if is_3f(data) else SCHEMES['FE'] if is_fe(data)
              else SCHEMES['UA'] if is_ua(data) else SCHEMES['F8'])
    elif n == 10240:
        bs = SCHEMES['DPC']
    elif n == 12288:
        bs = SCHEMES['FA']
    elif n == 16384:
        bs = SCHEMES['E7'] if is_e7(data) else SCHEMES['F6']
    elif n == 32768:
        bs = SCHEMES['F4']
        if is_3f(data):
            raise ValueError('3F carts bigger than 8 KB are not supported yet')
    else:
        raise ValueError('unusual cart size %d bytes' % n)
    if bs in (1, 2, 6) and not tag:
        sc = is_superchip(data)
    if bs == 0 and n < 4096:                # 3 KB odd dumps: pad to 4 KB
        data = data + bytes(4096 - n)
    cart = bs | (16 if sc else 0) | (len(data) << 8)
    return {'cart': cart, 'rom': bytes(data), 'scheme': NAMES.get(bs, '?') + (' + Superchip' if sc else ''),
            'kb': (len(data) + 1023) // 1024}


if __name__ == '__main__':
    for p in sys.argv[1:]:
        try:
            r = parse(open(p, 'rb').read(), p)
            print('%-50s %3d KB  %s' % (os.path.basename(p)[:50], r['kb'], r['scheme']))
        except ValueError as e:
            print('%-50s refused: %s' % (os.path.basename(p)[:50], e))
