# Real NES pads on Orphan

Plug an original NES controller into the S9 control board and play the **Orphan NES** console with it. The FPGA reads
the pad itself (the 4021 shift register inside it) about 1000 times a second, with NES timing. Real pads and the
browser pads (keyboard, USB gamepad) work together.

**Not tested with a NES controller, yet.** Built and simulated only; reports welcome as GitHub issues.

> [!CAUTION]
> # ⚠ DISCONNECT EVERY HASHBOARD FIRST
> Unplug **all** hashboards from J1..J9 before you plug in a pad or load the NES core. Any header can be a pad port,
> and the FPGA drives the LATCH and CLOCK pins of the headers you pick.

![Adapter wiring](adapter.svg)

> **3.3 V only.** The hashboard header pins go straight into the FPGA: no buffer, no protection, **not 5 V tolerant**.
> Power the pad from the header's 3.3 V pin (16), never from 5 V.

## What you need

- An S9 control board running Orphan, with the `orphan_nes` core
- An original NES controller. Its CD4021 is a CMOS chip that should run at 3.3 V (not yet checked against the
  datasheet or on a real pad). Some clone pads use other chips and may not run at 3.3 V.
- A 2x9 socket that fits the header on your board (check the pitch with calipers: 2.54 mm or 2.0 mm)
- An NES controller socket: the easiest is the socket end of an NES extension cable
- A multimeter (continuity and DC volts) and a soldering iron

## Wiring

| S9 header pin | Signal on the S9 board | NES socket | Official NES pad wire |
|---|---|---|---|
| 15 | RST (FPGA output) | LATCH (OUT) | orange |
| 11 | TXD (FPGA output) | CLOCK (CLK) | red |
| 12 | RXD (FPGA input) | DATA (D0) | yellow |
| 16 | 3.3 V | VCC (the "+5V" pin) | white |
| 1 (or 2, 9, 10, 13, 14) | GND | GND | brown |
| 5 | PLUG | tie to GND (pin 9) inside the adapter | none |

Leave every other header pin unconnected: 18 is EN (driven by the ARM), 3 and 4 are the board's I2C bus,
6, 7, 8 and 17 are not used by Orphan.
D3 and D4 on the NES socket stay unconnected (the standard pad does not use them).

**PLUG to GND matters:** it tells Orphan an adapter is on this header. The FPGA only drives LATCH and CLOCK on a
header you picked **and** whose PLUG pin is low. Without the jumper the pad is never read.

The wire colours are those of an official NES pad cable. Extension cables and clones use other colours:
find each wire with the continuity tester, against the socket drawing (front view, like the console's own port).

## Before you plug a pad in

1. **Check the header numbering under load.** The drawing uses the usual 2x9 numbering: pin 1 is the square pad, odd
   pins in one row, even pins in the other. With the board powered, put a 1 k resistor from pin 16 to pin 1 and
   measure across it: it must stay at **3.3 V**. (A plain voltage check is not enough: while an Orphan design with
   pull-ups is loaded, the signal pins also read about 3.3 V, but a weak pull-up drops to almost 0 V under 1 k.)
   If it does not hold 3.3 V, stop and find the 3.3 V and GND pins on your board first.
2. **Unplug every hashboard.** All of J1..J9 are available for pads, so no hashboard may be on the board while the NES
   core runs. Stock boards only have headers fitted on J6, J7 and J8; J1 to J5 and J9 are bare footprints you can
   solder a header into (do the pin 16 check there too). Optional extra safety: `ORPHAN_NES_PADS_NEVER=6,7` (or the
   line `6,7` in `/etc/orphan/nespads-never`) lists headers that are never driven or read.
3. **Empty-header test** (no pad plugged in yet, required on J6 to J8): start the console with your two headers picked
   (below) and check that it prints `no adapter` for both pads. On the first test board every header read empty (see
   Status), but J6 to J8 have resistors fitted nearby and boards may differ: a pull-down on PLUG would show up here as
   "adapter found" with nothing plugged in.

## Turn it on

The console reads pads on J1 (pad 1) and J2 (pad 2) unless told otherwise. Pick other headers with an environment
variable or a one-line file on the board:

```sh
ORPHAN_NES_PADS=7,8        # pad 1 on J7, pad 2 on J8
echo 7,8 > /etc/orphan/nespads
ORPHAN_NES_PADS=off        # real pads off
ORPHAN_NES_PADS_NEVER=6,7  # optional: never drive or read J6 and J7 (default: none)
```

When the console starts it prints, for example, `Real NES pads on J7,J8: pad 1 adapter found, pad 2 no adapter`.
The console's web page (port 8000) has an **NES pads** button: it shows each pad's header, whether an adapter is
found, and lights every button as you press it.

## How it works

- `games/orphan_nes/orphan_nespad.v`: the reader. LATCH high for 12 us, then 8 bits with 6 us clock halves
  (A, B, Select, Start, Up, Down, Left, Right; low = pressed), one scan every 1.002 ms.
  A read no real pad can give (Up + Down or Left + Right at once) counts as no buttons, so a DATA line stuck
  low can not jam a game.
- `orphan_nespad_ports` (same file) and `games/orphan_nes/top.v`: a 9-header crossbar, so any of J1 to J9 can be pad 1
  or pad 2. A header is driven only while it is picked, its own PLUG pin reads low and it is not protected. The FPGA's
  weak pull-ups are on for all 36 header pins.
- `games/orphan_nes/orphan_nes_block.v`, register 9 `HWPADS`: write `[0]` enable, `[7:4]` pad 1 header,
  `[11:8]` pad 2 header (1 to 9); read `[15:0]` the buttons, `[17:16]` pads being read, `[24]` enable.
  Register 10 reads both header numbers. Register 11 `HWNEVER`: `[8:0]` optional protected headers (bit n-1 = Jn),
  none after the FPGA loads. Real pads are off after the FPGA loads, until `main.py` turns them on; `main.py` turns them off
  again when it exits.
- `games/sim/tb_nespad.v` (the reader against a model of the 4021, 15 checks) and `games/sim/tb_nespad_ports.v`
  (the crossbar: switching headers mid-scan, PLUG high, a protected header with PLUG low, 13 checks), Icarus Verilog.

Pad facts (button order, latch and clock behaviour, wire colours, socket layout) are from the NESdev wiki:
[Standard controller](https://www.nesdev.org/wiki/Standard_controller) and
[Controller port pinout](https://www.nesdev.org/wiki/Controller_port_pinout).

## Status

**Not tested with a NES controller, yet.** Reports welcome as GitHub issues.

- Simulation: the reader against a model of the 4021 (15 checks) and the header crossbar (13 checks).
- First board test (2026-11-25, one S9 board, no pad plugged in): the console loaded, and J1, J2, J3, J4, J5, J7, J8
  and J9 all read "no adapter" with no buttons over about 200 scans each. So on that board nothing on those headers
  pulls PLUG or DATA low against the FPGA's pull-ups (the resistors fitted near J6 to J8 do not fake an adapter on J7
  or J8). J6 had a hashboard on it and was listed in `ORPHAN_NES_PADS_NEVER=6`, so it was never driven or read.
  Still: disconnect every hashboard before you use real pads.

The drawing is made by `docs/nes-pad/make_adapter_svg.py` (it writes the same SVG for the docs, the website and the
console's page).

---
by JMSCNC, makers of RotatoCAM · [Rev. J. Money - 2026] · GPL-3.0-or-later
