"""Orphan Games, PC Engine / TurboGrafx-16: HuCard images (.pce) for orphan_pce.
A .pce file is the card's ROM, sometimes after a 512-byte copier header (dropped here). The card goes into the
board's DDR (nesddr.CartStore, 4 MB) and the core's ROM_SZ (register 2, in 4 KB units) picks the chip mapping:
128K / 256K / 512K repeat, 384K and 768K split like the real cards, 2.5 MB = Street Fighter II's mapper.
Some US TurboGrafx dumps are bit-reversed (the US cards swap the data lines): when the reset vector's high byte
only makes sense reversed, every byte is reversed back.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""

MAX = 4 << 20
REV = bytes(int('{:08b}'.format(i)[::-1], 2) for i in range(256))


def parse(data, name=''):
    if len(data) % 8192 == 512:
        data = data[512:]
    if not data or len(data) % 8192:
        raise ValueError('a HuCard image is a multiple of 8 KB (this one: %d bytes)' % len(data))
    if data[0x1FFF] < 0xE0 and REV[data[0x1FFF]] >= 0xE0:          # a bit-reversed US dump
        data = data.translate(REV)
    if len(data) > MAX:
        raise ValueError('HuCard too big (%d KB, at most %d KB)' % (len(data) >> 10, MAX >> 10))
    size = len(data)
    img = bytearray(data)
    # small cards: repeat to 128 KB (the core repeats 128K / 256K / 512K by itself, anything else maps straight)
    while len(img) < 128 << 10:
        img += data
    units = max(size, 128 << 10) >> 12
    return {'rom': bytes(img), 'sz': units, 'kb': size >> 10}


def ddr_image(cart):
    """The whole card, padded to the next 4 KB (the page table maps 4 KB pages)."""
    r = cart['rom']
    return r + bytes(-len(r) % 4096)
