"""Draws the NES pad adapter diagram (docs/nes-pad, site/img, games/orphan_nes): the NES pad adapter for Orphan (S9 hashboard header -> NES controller socket).
Run: python docs/nes-pad/make_adapter_svg.py      by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import os

INK, LIME, GOLD, TXT, DIM, LINE = '#080a0c', '#d2ff51', '#ffb02e', '#e8efe6', '#7d8a7c', '#364239'
# official NES pad wire colours (NESdev wiki), lightened a little where they would vanish on the dark ground
C = {'GND': '#c08a5a', 'CLK': '#ff5a4f', 'LATCH': '#ff9a2e', 'DATA': '#ffe14d', 'VCC': '#f4f6f2', 'PLUG': LIME}
FONT = "'IBM Plex Mono',Consolas,ui-monospace,monospace"

def px(n):                      # header pin -> (x, y): odd pins top row, even pins bottom row, pin 1 at the left
    c = (n - 1) // 2
    return 110 + c * 52, 262 if n % 2 else 318

ROLE = {1: 'GND', 2: 'GND', 9: 'GND', 10: 'GND', 13: 'GND', 14: 'GND', 5: 'PLUG', 11: 'CLK', 12: 'DATA', 15: 'LATCH', 16: 'VCC'}
HOLE = {'GND': (930, 190), 'CLK': (930, 250), 'LATCH': (930, 310), 'DATA': (930, 370),
        'VCC': (1040, 250), 'D3': (1040, 310), 'D4': (1040, 370)}
HOLE_LABEL = {'GND': 'GND', 'CLK': 'CLOCK', 'LATCH': 'LATCH', 'DATA': 'DATA', 'VCC': 'VCC', 'D3': 'D3 n/c', 'D4': 'D4 n/c'}

out = []
w = out.append
w('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1240 540" role="img" '
  'aria-labelledby="t d" font-family="%s">' % FONT)
w('<title id="t">Orphan NES pad adapter wiring</title>')
w('<desc id="d">S9 hashboard header pin 15 RST to the NES socket LATCH, pin 11 TXD to CLOCK, pin 12 RXD from DATA, '
  'pin 16 3.3 V to VCC, pin 1 GND to GND, and pin 5 PLUG tied to pin 9 GND. 3.3 V only.</desc>')
w('<rect width="1240" height="540" fill="%s"/>' % INK)
w('<text x="40" y="52" fill="%s" font-size="26" font-weight="700" letter-spacing="2">ORPHAN NES PAD ADAPTER</text>' % LIME)
w('<text x="40" y="78" fill="%s" font-size="14">a real NES controller on an S9 hashboard header, read by the FPGA</text>' % DIM)
# 3.3 V badge
w('<rect x="900" y="30" width="300" height="52" rx="4" fill="#2a1a08" stroke="%s"/>' % GOLD)
w('<text x="1050" y="53" fill="%s" font-size="17" font-weight="700" text-anchor="middle">3.3 V ONLY</text>' % GOLD)
w('<text x="1050" y="72" fill="%s" font-size="12" text-anchor="middle">these pins are not 5 V tolerant</text>' % TXT)

def wire(pts, col):
    d = 'M' + ' L'.join('%d %d' % p for p in pts)
    w('<path d="%s" fill="none" stroke="%s" stroke-width="10" stroke-linejoin="round"/>' % (d, INK))   # halo
    w('<path d="%s" fill="none" stroke="%s" stroke-width="4" stroke-linejoin="round" stroke-linecap="round"/>' % (d, col))

def lane_label(x, y, text, col):
    w('<text x="%d" y="%d" fill="%s" font-size="13" font-weight="600">%s</text>' % (x, y, col, text))

# the socket body goes under the wires (they run into its holes); the header body goes over them
w('<path d="M885 160 L975 160 L1080 215 L1080 405 L885 405 Z" fill="#101613" stroke="#596e3e" stroke-width="2"/>')
# wires
x, y = px(1);  wire([(x, y), (x, 120), (800, 120), (800, 190), (930, 190)], C['GND'])
x, y = px(11); wire([(x, y), (x, 150), (770, 150), (770, 250), (930, 250)], C['CLK'])
x, y = px(15); wire([(x, y), (x, 180), (740, 180), (740, 310), (930, 310)], C['LATCH'])
x, y = px(16); wire([(x, y), (x, 440), (1170, 440), (1170, 250), (1040, 250)], C['VCC'])
x, y = px(12); wire([(x, y), (x, 400), (860, 400), (860, 370), (930, 370)], C['DATA'])   # crosses VCC: halo bridge
a, b = px(5), px(9); wire([a, (a[0], 200), (b[0], 200), b], C['PLUG'])

lane_label(560, 112, 'pin 1 GND  -&gt;  GND', C['GND'])
lane_label(560, 142, 'pin 11 TXD -&gt;  CLOCK', C['CLK'])
lane_label(560, 172, 'pin 15 RST -&gt;  LATCH', C['LATCH'])
lane_label(560, 392, 'pin 12 RXD &lt;-  DATA', C['DATA'])
lane_label(560, 432, 'pin 16 3.3 V -&gt; VCC', C['VCC'])
w('<text x="%d" y="194" fill="%s" font-size="12" font-weight="600">PLUG to GND</text>' % (px(5)[0] - 92, LIME))

# header body + pins
w('<rect x="80" y="222" width="476" height="130" rx="6" fill="#101613" stroke="#596e3e" stroke-width="2"/>')
for n in range(1, 19):
    x, y = px(n)
    role = ROLE.get(n)
    used = n in (1, 5, 9, 11, 12, 15, 16)
    col = C[role] if role else '#3a463d'
    shape = ('<rect x="%d" y="%d" width="18" height="18" fill="%s" stroke="%s" stroke-width="3"/>' % (x - 9, y - 9, INK if not used else col, col)
             if n == 1 else
             '<circle cx="%d" cy="%d" r="9" fill="%s" stroke="%s" stroke-width="3"/>' % (x, y, col if used else INK, col))
    w(shape)
    ty = y - 16 if n % 2 else y + 27
    w('<text x="%d" y="%d" fill="%s" font-size="12" text-anchor="middle">%d</text>' % (x, ty, TXT if used else DIM, n))
w('<text x="80" y="378" fill="%s" font-size="13" font-weight="700" letter-spacing="1">S9 HASHBOARD HEADER (J1..J9)</text>' % LIME)
w('<text x="80" y="398" fill="%s" font-size="12">seen from above, pin 1 = square pad</text>' % DIM)
w('<text x="80" y="470" fill="%s" font-size="12">brown rings: other GND pins (2, 10, 13, 14)</text>' % DIM)
w('<text x="80" y="490" fill="%s" font-size="12">dark pins: leave unconnected (18 = EN, 3/4 = board I2C, 6/7/8/17)</text>' % DIM)

# NES socket, front view like the console's port (NESdev wiki layout)
for k, (x, y) in HOLE.items():
    nc = k in ('D3', 'D4')
    col = '#3a463d' if nc else C[k]
    w('<circle cx="%d" cy="%d" r="11" fill="%s" stroke="%s" stroke-width="3"/>' % (x, y, INK if nc else col, col))
    w('<text x="%d" y="%d" fill="%s" font-size="11" text-anchor="middle">%s</text>' % (x, y + 27, DIM if nc else TXT, HOLE_LABEL[k]))
w('<text x="885" y="490" fill="%s" font-size="13" font-weight="700" letter-spacing="1">NES CONTROLLER SOCKET</text>' % LIME)
w('<text x="885" y="510" fill="%s" font-size="12">front view, like the console port</text>' % DIM)
w('<text x="40" y="528" fill="%s" font-size="11">by JMSCNC, makers of RotatoCAM · github.com/revjmoney/orphan</text>' % '#56635a')
w('<text x="1200" y="528" fill="%s" font-size="11" text-anchor="end">Not tested with a NES controller, yet.</text>' % GOLD)
w('</svg>')
root = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
for rel in ('docs/nes-pad/adapter.svg', 'site/img/nes-pad-adapter.svg', 'games/orphan_nes/adapter.svg'):
    p = os.path.join(root, rel)            # repo docs, the website, and the NES core's own page (main.py serves it)
    open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')
    print(p)
