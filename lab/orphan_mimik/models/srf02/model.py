"""MIMIK chip model: SRF02. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""

UNIT = {0x50: 1 / 2.54, 0x51: 1.0, 0x52: 58.0}      # inches, cm, microseconds (round trip at 58 us per cm)
state = {'unit': 0x51}


def setup(chip):
    chip.put(0, [6, 0x80, 0, 0, 0, 15])
    chip.ro(0, 6)


def update(chip, v):
    r = max(0, min(0xFFFF, round(v['distance'] * UNIT[state['unit']])))
    chip.put(2, [r >> 8, r & 0xFF])


def on_event(chip, e, v):
    if e['kind'] == 'BLOCKED' and e['addr'] == 0 and e['data'] in UNIT:    # a command (register 0 is read-only)
        state['unit'] = e['data']
        update(chip, v)
