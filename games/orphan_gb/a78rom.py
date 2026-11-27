"""Orphan Games, Atari 7800: cart images for orphan_a78.
An .a78 file starts with a 128-byte header ("ATARI7800" at byte 1): cart size (bytes 49-52, big endian), cart
flags (53-54: POKEY, SuperGame banking, RAM at $4000, ...), XM (63) and, from header version 4, a mapper (64).
A file without that header is taken as a plain cart (no flags). Up to 128 KB (the core keeps the cart in block RAM).
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
MAX = 128 << 10


def parse(data, name=''):
    flags = xm = mapper = 0
    hdr = False
    if len(data) >= 128 and data[1:10] == b'ATARI7800':
        hdr = True
        ver = data[0]
        flags = data[53] << 8 | data[54]
        xm = data[63]
        mapper = data[64] if ver >= 4 else 0
        size = int.from_bytes(data[49:53], 'big')
        data = data[128:]
        if 0 < size <= len(data):
            data = data[:size]
    if not data or len(data) > MAX:
        raise ValueError('7800 cart of %d KB (at most %d KB)' % (len(data) >> 10, MAX >> 10))
    return {'rom': bytes(data), 'cart': flags | xm << 16 | mapper << 24, 'size': len(data), 'kb': len(data) >> 10,
            'header': hdr}
