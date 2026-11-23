# ORPHAN LOGIC LAB: SPEKTOR / INJEKTOR 3000

**[orphan]** · by JMSCNC, makers of RotatoCAM · [Rev. J. Money - 2026] · GPL-3.0-or-later

[![Buy me a coffee](https://img.shields.io/badge/%E2%98%95-Buy%20me%20a%20coffee-ffcc2e)](https://buymeacoffee.com/revjmoney)

A 16-channel logic analyzer built into the FPGA of a retired Antminer S9 control board (Zynq XC7Z010).
SPEKTOR captures, triggers and decodes. INJEKTOR, the signal output half (replay, pattern generator,
protocol drive, MITM, JTAG finder, glitcher), arrives with the next core build; its bay is already in the page.

![SKOPE](../../docs/screenshots/spektor-skope.png)

## What it does

| | |
|---|---|
| Channels | 16, 3.3 V LVCMOS, on four hashboard headers |
| Sample rate | 100 MSa/s down to 1 kSa/s (100 MHz / (DIV + 1)) |
| RAW depth | 32,768 samples (two per 32-bit block RAM word) |
| RLE depth | 16,384 runs of up to 65,536 samples each: seconds of a slow bus |
| Trigger | 4-stage sequencer. Per stage: level (0/1/X) and rise/fall/any edge per channel, plus a repeat count |
| Trigger position | sample-exact in RAW and RLE (the trigger sample always starts its own RLE run) |
| Pre/post | 10/90, 25/75, 50/50, 75/25, 95/5 of the ring |
| Dekoders | UART (5 to 9 bits, parity, invert, auto-baud), I2C (start, repeated start, stop, address R/W, ACK/NAK), SPI (modes 0 to 3, MSB/LSB first, CS framing) |
| Export | VCD (PulseView, GTKWave), CSV, JSON kapture files you can load back |

## Quick start

1. In the Orphan menu: **Load core** then `orphan_spektor` (or `ardzy load orphan_spektor`). The page opens on port 8000.
2. Tick **TEST SIGNAL** and press **ARM**. The built-in pattern (counter bits) fills the SKOPE.
3. Wire real signals (3.3 V only, see below), set a trigger on **TRIGGR**, pick RATE and MODE, press **ARM**.
4. Add a dekoder on **DEKODE**. Save a **VCD** for PulseView.

## Wiring

Every hashboard header (J1 to J9) is a 2x9, 2.54 mm header, and pins 5, 11, 12 and 15 of each go straight into the
FPGA: 36 inputs in all. SPEKTOR wires all 36 in and a **kanal map** (a crossbar in the FPGA) picks which header pin
each of CH0..CH15 samples. Change it on PROBEZ card 1, or in the terminal (`map 3 J1.11`, `map stock`); it is saved
on the board.

Default map (the S9's stock headers first; the stock ribbon cables fit J6, J7, J8):

| Header | pin 5 | pin 11 | pin 12 | pin 15 |
|---|---|---|---|---|
| J6 | CH0 | CH1 | CH2 | CH3 |
| J7 | CH4 | CH5 | CH6 | CH7 |
| J8 | CH8 | CH9 | CH10 | CH11 |
| J9 | CH12 | CH13 | CH14 | CH15 |

- Stock boards have only J6, J7, J8 fitted. For the others solder a 2x9 2.54 mm pin header into the footprint;
  the pins connect straight to the FPGA, nothing to jumper.
- GND on pins 1, 2, 9, 10, 13, 14. 3.3 V out on pin 16 (small loads only). Pin 18 is EN from the ARM side: leave it alone.
- **3.3 V only.** No buffer, no protection, not 5 V tolerant. For 5 V logic build the 74LVC245A front end (PROBEZ card 3).
- The board has no pull-ups on these pins (measured 2026-11-22). SPEKTOR turns on the FPGA's weak internal
  pull-ups, so an unconnected channel reads 1.
- PROBEZ card 1 also shows all 36 pins live (a ring = high): a pin finder for unknown wiring.
- Check pin 1 with a meter before your first harness: GND on pins 1 and 2.

The **PROBEZ** page has 8 slide-in cards with drawings: the ports, a 16-channel ribbon harness, the 5 V front end,
a UART tap, an I2C klip (24Cxx), an SPI flash klip (25xx), JTAG/SWD hunter leads, and the limits.

## The page

Menu bar (keys 1 to 7), a status line, the kapture bar, and pages that slide in from the side:

- **SKOPE**: the waveforms. Wheel zooms at the mouse, drag pans, click sets cursor A, shift-click or right-click sets B
  (time, delta, 1/delta and samples between). Click a channel label to hide it, double-click to rename it
  (names are saved on the board). Dense areas draw as solid blocks. Dekoder lanes run under the channels.
- **TRIGGR**: a channel x stage grid. Click a cell to cycle `X 0 1 ↑ ↓ ↕` (shift-click goes back). TIMES = matching
  samples the stage needs. Presets: rising edge, UART start bit, I2C START, SPI chip select, two-stage glitch hunt, Nth edge.
- **DEKODE**: add UART, I2C and SPI dekoders; a listing (click a row to jump there) and the UART text stream.
- **MEETRZ**: per channel edges, frequency, duty, min/max high and low pulse; a cursor table with edges and levels at A and B.
- **LOGZ**: the last 12 kaptures of this browser tab (view, VCD, CSV), save/load JSON, the event log.
- **PROBEZ**: probe builder cards (arrow keys flip them).
- **INJEKTOR**: the output modules and their pins.
- **PROBEZ card 1**: the kanal map editor and the live pin view of all 9 headers.
- **TERMINAL**: a drawer that slides in from the right (the ` key or the tab on the right edge).

Keys: `1`-`7` pages, `A` arm, `F` force, `S` stop, `T` center the trigger, `0` fit, `+`/`-` zoom, arrows pan, `` ` `` terminal, `Esc` close it.
Links: `#skope`, `#triggr`, `#dekode`, `#meetrz`, `#logz`, `#probez-3` (card 3), `#injektor`.

### Terminal commands

```
arm [raw|rle] [rate 1M] [test]   arm the trigger
force | stop                     trigger now | stop and read
status                           state, rate, live pins
trig <ch> <x|0|1|r|f|e> [stage]  set a trigger cell, "trig clear"
name <ch> <text>                 rename a channel
uart <ch> [baud|auto]            add a UART dekoder
i2c <scl> <sda> | spi <clk> <mosi> <miso> <cs> [mode]
dump [n]                         print dekoded frames
meas <ch>                        frequency and duty
vcd | csv                        save the kapture
page <name>                      switch page
```

## How the trigger works

Each stage has a MASK/VALUE (levels), a RISE mask and a FALL mask (a channel in both = any edge) and a COUNT.
A stage matches on a sample when every masked channel has its level, every RISE channel just went 0 to 1 and every
FALL channel just went 1 to 0. It must match COUNT + 1 samples (they need not be back to back), then the next stage
arms; the last used stage fires the trigger. With no conditions at all the page simply captures at once.

## Inside

| File | What |
|---|---|
| `spektor.v` | the capture core: input synchronizers, test pattern, divider, RAW/RLE packer, trigger sequencer, 16384 x 32 block RAM ring, pop-read port |
| `top.v`, `pins.xdc` | slot 0 info ("SPK1"), slot 1 SPEKTOR, slot 15 fans; all 36 header pins with weak pull-ups; LED D5 armed, D6 triggered |
| `spektor_hw.py` | `Spektor` class: `arm()`, `force()`, `stop()`, `read()` (runs), `to_vcd()` |
| `main.py` | web service on port 8000: `/api/status`, `/api/capture`, `/api/vcd`, POST `arm`/`force`/`stop`/`fetch`/`names` |
| `index.html` | the page |

Registers (slot 1, word index): 0 CTRL (arm, stop, force), 1 STATUS, 2 DIV, 3 MODE (rle, test, stages-1), 4 POST,
5 TRIG_AT (RAW `{word, half}`, RLE word), 6 WPTR, 7 FILLED, 8 LIVE, 9 SAMPLES, 10+4s MASK|VALUE, 11+4s RISE|FALL,
12+4s COUNT, 30 RDPTR, 40+c channel c's header pin (0..35), 56/57 the raw 36 pins, 768..1023 ring pop, 127 ID.

From Python on the board:

```python
from spektor_hw import Spektor
s = Spektor()
s.arm(div=9, rle=False, post=8192, stages=[{'fall': 1 << 0}])   # 10 MSa/s, trigger on CH0 falling
values, counts, trig, rle = s.read()                              # runs of 16-bit samples
```

Tested on hardware (board 2): edge spacing exact in RAW and RLE, rise/fall/any/level+edge triggers land on the exact
sample in both modes, the divider, force and stop; the UART, I2C and SPI dekoders against known bytes.

## Roadmap: INJEKTOR

Protocol drive (UART/I2C/SPI master), rekord/replay of kaptures, pattern generator, DDS/PWM, MITM bridge,
JTAG/SWD finder, GLITCHR; a SUMP/sigrok link so PulseView can drive SPEKTOR directly; sigrok-cli in the distro.

Built on Ardzy (by chryso, GPL-3.0): ardzy_bus, ardzy_info, the board tools. "Bus Pirate" is a trademark of its owners;
SPEKTOR / INJEKTOR is an independent design.

---
[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM · [Buy me a coffee](https://buymeacoffee.com/revjmoney)
