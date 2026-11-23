#!/usr/bin/env python3
"""INTERSEKTOR hardware test on the board (orphan_spektor loaded, its program stopped: ardzy stop).
The built-in test transmitters play device A and device B; INTERSEKTOR drives its real output pins (J7.11 to B,
J6.11 to A); SPEKTOR captures those pins from their pads and this script decodes the UART from the raw samples
(its own decoder, not the core's) and compares. Nothing may be wired to J6.11 / J7.11 while this runs.
   python3 ik_hw_test.py
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import sys
import time

from intersektor_hw import Intersektor, RuleEngine
from spektor_hw import Spektor

sp = Spektor()
ik = Intersektor(sp.bus)
fails = []
RATE = 10e6                                    # SPEKTOR at 10 MSa/s (div 9)
CH_TO_A, CH_TO_B = 1, 5                        # default kanal map: CH1 = J6.11, CH5 = J7.11


def check(name, ok, info=''):
    print('%-4s %s %s' % ('ok' if ok else 'FAIL', name, info), flush=True)
    if not ok:
        fails.append(name)


def capture(fn, wait=0.05):
    """Run fn() while SPEKTOR records (RLE, 10 MSa/s), return (values, counts)."""
    sp.set_map(list(range(20, 36)))
    sp.arm(div=9, rle=True, post=16384)
    sp.force()
    time.sleep(0.002)
    fn()
    time.sleep(wait)
    sp.stop()
    v, c, _, _ = sp.read()
    return v, c


def uart_decode(values, counts, chn, baud):
    """8N1 from runs: find each falling edge, sample the middle of every bit."""
    bit = RATE / baud
    t, edges, level = 0, [], []
    for v, c in zip(values.tolist(), counts.tolist()):
        edges.append(t)
        level.append((v >> chn) & 1)
        t += c
    end = t

    def at(x):
        lo, hi = 0, len(edges) - 1
        while lo < hi:
            m = (lo + hi + 1) // 2
            if edges[m] <= x:
                lo = m
            else:
                hi = m - 1
        return level[lo]

    out, ferr, i = bytearray(), 0, 1
    x = 0
    while True:
        # next falling edge at or after x
        k = next((j for j in range(i, len(edges)) if edges[j] >= x and level[j] == 0 and level[j - 1] == 1), None)
        if k is None:
            break
        s = edges[k]
        if s + 10 * bit > end:
            break
        b = 0
        for n in range(8):
            b |= at(s + (1.5 + n) * bit) << n
        if at(s + 9.5 * bit):
            out.append(b)
        else:
            ferr += 1
        x, i = s + 9.6 * bit, k + 1
    return bytes(out), ferr


def setup(m0, m1, baud=115200, test=True):
    ik.set_ctrl(go=False, test=test)
    for d, m in ((0, m0), (1, m1)):
        ik.set_dir(d, mode=m, baud=baud, rx=(20, 24)[d], tx=(25, 21)[d])
        ik.clear_table(d)
    time.sleep(0.01)
    ik.clear_log()
    ik.clear_counts()
    ik.set_ctrl(go=True)


def drain():
    return ik.log()


# ---- basics
check('core ID IKT1', ik.rd(127) == 0x494B5431)
ik.set_ctrl(go=False, test=False)
time.sleep(0.01)
pins = sp.raw_pins()
check('GO off: J6.11 / J7.11 float high (pull-ups)', (pins >> 21) & 1 and (pins >> 25) & 1, hex(pins))

# ---- RELAY both ways, checked on the pins by SPEKTOR
setup(2, 2)
msg_a, msg_b = b'Hello B, this is A. INTERSEKTOR 3000!', b'B answers: 0123456789'
v, c = capture(lambda: (ik.test_send(0, msg_a), ik.test_send(1, msg_b)))
got_b, fb = uart_decode(v, c, CH_TO_B, 115200)
got_a, fa = uart_decode(v, c, CH_TO_A, 115200)
check('RELAY A->B on J7.11 (SPEKTOR decode)', got_b == msg_a and fb == 0, repr(got_b))
check('RELAY B->A on J6.11 (SPEKTOR decode)', got_a == msg_b and fa == 0, repr(got_a))
st = ik.status()
check('both pins driven, no conflict', st['dirs'][0]['driving'] and st['dirs'][1]['driving'] and not st['conflict'])
ents = drain()
check('log: every byte IN and OUT, both ways',
      sum(1 for e in ents if e[0] == 1 and e[1] == 0) == len(msg_a) and sum(1 for e in ents if e[0] == 6 and e[1] == 0) == len(msg_a)
      and sum(1 for e in ents if e[0] == 1 and e[1] == 1) == len(msg_b), '%d entries' % len(ents))
outs = bytes(e[2] for e in ents if e[0] == 6 and e[1] == 0)
check('log OUT bytes match the pin', outs == msg_a)

# ---- other baud rates
for baud in (9600, 1000000):
    setup(2, 0, baud)
    v, c = capture(lambda: ik.test_send(0, b'baud test'), wait=0.02 + 12 * 10 / baud)
    g, f = uart_decode(v, c, CH_TO_B, baud)
    check('RELAY at %d baud' % baud, g == b'baud test' and f == 0, repr(g))

# ---- the swap table (FPGA)
setup(2, 2)
ik.table(0, ord('l'), ord('L'))
ik.table(0, ord('o'), drop=True)
v, c = capture(lambda: ik.test_send(0, b'hello world'))
g, _ = uart_decode(v, c, CH_TO_B, 115200)
check('swap l->L, drop o: heLL wrLd on the pin', g == b'heLL wrLd', repr(g))
e = ik.status()['dirs'][0]
check('ERRS: 3 swapped, 2 dropped', e['swapped'] == 3 and e['dropped'] == 2, str(e))

# ---- inject
setup(2, 2)
v, c = capture(lambda: ik.inject(1, b'INJEKTED\r\n'))
g, _ = uart_decode(v, c, CH_TO_A, 115200)
check('INJEKT B->A on J6.11', g == b'INJEKTED\r\n', repr(g))

# ---- WIRE
setup(1, 0)
time.sleep(0.01)
v, c = capture(lambda: ik.test_send(0, b'wire mode'))
g, _ = uart_decode(v, c, CH_TO_B, 115200)
check('WIRE passes bits to J7.11', g == b'wire mode', repr(g))

# ---- HOLD with a sequence rule (the ARM rewrites, like main.py does)
setup(3, 0)
eng = RuleEngine()
eng.set_rules([(b'password', b'********'), (b'AT+RST', b'')])


def hold_run():
    ik.test_send(0, b'login password ok AT+RST done')
    t = time.time()
    while time.time() - t < 0.2:
        ik.heartbeat()
        out = b''
        for k, d, b, o, ts in ik.log():
            if k == 4:
                out += eng.feed(bytes([b]))
        out += eng.flush_due()
        if out:
            ik.inject(0, out)
        time.sleep(0.002)


v, c = capture(hold_run)
g, _ = uart_decode(v, c, CH_TO_B, 115200)
check('HOLD + rules: password masked, AT+RST removed', g == b'login ******** ok  done', repr(g))

# ---- failsafe: stop the heartbeat for 300 ms
setup(3, 0)
time.sleep(0.3)
st = ik.status()
check('FAILSAFE after 250 ms without heartbeat', st['dirs'][0]['failsafe'])
v, c = capture(lambda: ik.test_send(0, b'still flowing'))
g, _ = uart_decode(v, c, CH_TO_B, 115200)
check('FAILSAFE relays the bytes', g == b'still flowing', repr(g))
ik.heartbeat()
check('heartbeat ends FAILSAFE', not ik.status()['dirs'][0]['failsafe'])

# ---- the baud finder
setup(2, 0, 57600)
ik.wr(16 + 5, 0)
ik.test_send(0, b'\x55\x55')
time.sleep(0.01)
st = ik.status()['dirs'][0]
check('baud finder: 57600', st['baud_guess'] == 57600, str(st['minp']))

# ---- pin conflict
setup(2, 2)
ik.set_dir(1, rx=24, tx=20)
time.sleep(0.01)
st = ik.status()
check('conflict: B->A told to drive A\'s input pin, not driven', st['conflict'] and not st['dirs'][1]['driving'])

# ---- off again
ik.set_ctrl(go=False, test=False)
for d in range(2):
    ik.set_dir(d, mode=0, rx=(20, 24)[d], tx=(25, 21)[d], baud=115200)
time.sleep(0.01)
check('GO off releases the pins', not any(x['driving'] for x in ik.status()['dirs']))
sp.set_map(list(range(20, 36)))
print('\n%d failed' % len(fails) + (': ' + ', '.join(fails) if fails else ''))
sys.exit(1 if fails else 0)
