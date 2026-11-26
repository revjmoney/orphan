"""Master System / Game Gear ROM -> what the Orphan SMS block needs: the CART register value and the ROM bytes.
    py -3 smsrom.py game.sms        prints the CART value and the mode
Game Gear mode comes from the file name (.gg). Carts up to 128 KB (the block RAM cart in orphan_sms_block.v).
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import sys

ROM_MAX = 128 * 1024


def parse(data, name=''):
    data = bytes(data)
    if len(data) % 16384 == 512:               # an old copier header in front
        data = data[512:]
    if len(data) < 1024:
        raise ValueError('not a Master System / Game Gear ROM')
    if len(data) > ROM_MAX:
        raise ValueError('ROM too big for the block RAM cart (%d KB, max 128)' % (len(data) // 1024))
    banks = 1
    while banks * 16384 < len(data):
        banks *= 2
    return {'cart': banks - 1, 'rom': data, 'kb': max(1, len(data) // 1024), 'gg': name.lower().endswith('.gg')}


if __name__ == '__main__':
    c = parse(open(sys.argv[1], 'rb').read(), sys.argv[1])
    print('CART=%d  %s  %d KB' % (c['cart'], 'Game Gear' if c['gg'] else 'Master System', c['kb']))
