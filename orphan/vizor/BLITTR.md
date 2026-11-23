# BLITTR and HDMI: design note

**Status:** step 1 (the X desktop without the FPGA) is built and working; the BLITTR core and HDMI are design only.

[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM · GPL-3.0-or-later

## What it is for

VIZOR's own windows (the shell, KORES, every core's web page) are drawn by the viewer's browser, so they are already
fast. BLITTR is for real Linux GUI programs that only speak X11 (PulseView, GTKWave, a file manager, a text editor):
they run on the board in a virtual screen, and BLITTR sends only the parts of that screen that changed into a VIZOR
window. HDMI is the same picture on a real monitor plugged into the board.

## The hard numbers

| | |
|---|---|
| Network | the S9 board has **Fast Ethernet: 100 Mbit/s, about 11 MB/s** usable |
| A 1280 x 720 screen at 16 bits | 1.8 MB: a full redraw is about 6 per second over the network |
| A 1024 x 600 screen at 16 bits | 1.2 MB: about 9 full redraws per second |
| Typical desktop use (typing, a menu, a moving plot) | a few percent of the tiles change: tens of frames per second is possible |
| The ARM | 2 x Cortex-A9 at 667 MHz; comparing a whole frame in numpy costs tens of milliseconds |
| HP0 DDR port into the FPGA | hundreds of MB/s: a whole-frame compare in a few milliseconds |

So the win is in sending **only changed tiles**, and the FPGA's job is to find them (and squeeze them) without
using the ARM.

## The pipeline

```
X11 app -> Xvfb (virtual screen in DDR, 16-bit) --+--> BLITTR core (FPGA, reads DDR over HP0):
                                                  |      16 x 16 tiles: compare with the last frame, mark dirty tiles,
                                                  |      run-length pack each dirty tile, write a tile list to DDR
                                                  +--> vizor.py (ARM): reads the tile list, sends it on /ws/screen
browser: a VIZOR window with a <canvas> draws the tiles; mouse and keys go back on the same WebSocket -> XTest
```

- **Tiles**: 16 x 16 pixels, 512 bytes each at 16 bits. A 1280 x 720 screen is 80 x 45 = 3600 tiles.
- **Dirty test**: the core keeps a 32-bit checksum per tile in block RAM (3600 x 4 bytes = 14 KB, fits easily) and
  compares instead of keeping a whole second frame.
- **Packing**: run-length per tile (desktops are flat colours), raw if packing does not help. The browser unpacks
  in JavaScript.
- **Timing**: the ARM triggers a scan when Xvfb reports damage (XDamage), at most 30 times a second.
- **DDR access**: the same single-address gather reads Orphan TinyLM uses on this board (burst reads scramble at
  75 MHz), and HP0 must be switched to 64-bit mode first (`set_hp0_64bit`, see TinyLM).

### Step 1: no FPGA at all (BUILT 2026-11-22)

Measured on board 2, 1280 x 720 x 16: the numpy tile scan takes **54 ms per frame** (48 ms best) on one A9 core;
zlib level 1 packs a full screen from 1800 KB to 56 KB in 107 ms. So the scan, not the network, is the limit:
about 10 to 18 updates a second while it keeps one core busy. BLITTR's target: the same scan in a few milliseconds
with the ARM idle.

(Original plan:)

Xvfb + a small window manager + numpy tile checksums on the ARM + `/ws/screen` + a canvas window in VIZOR.
This gives a working remote X desktop and the real numbers. BLITTR then replaces only the checksum and packing
step, and the speed-up is measured against step 1.

Needs packages on the board (apt, Rev's OK first): `xvfb`, a light window manager (`jwm` or `icewm`),
`python3-xlib` (XTest input), and the apps to show (`pulseview`, `gtkwave`).

### Step 2: the BLITTR core

Slot 1 of an Orphan design (`orphan_blittr`), with the usual slot 0 info and slot 15 fan blocks. Registers: frame
base address, stride, width and height in tiles, a start bit, a done bit, the tile-list address and count. Because
the FPGA holds one core at a time, BLITTR is its own core: load it when you want the fast X desktop. VIZOR falls back
to step 1 when it is not loaded.

## HDMI out

### What the toolchain can do

Ardzy's own tests of this toolchain (Yosys + nextpnr-himbaechel + fasm2bit) on the XC7Z010:

- works: logic, block RAM, DSP, **MMCM/PLL**, **ODDR**, IOBUF/OBUF
- **OSERDESE2 does not work** (the pin never toggles), so the usual 10:1 hardware serializer is out
- TMDS_33 (true TMDS output) is not tested

### The plan: the PicoDVI way

PicoDVI (Luke Wren, Raspberry Pi Pico) drives a DVI monitor straight from 3.3 V pins through **270 ohm series
resistors**, each pair driven as two opposite single-ended signals. We do the same:

- 640 x 480 at 60 Hz: 25 MHz pixel clock, **250 Mbit/s per data pair**.
- An MMCM makes 25 MHz and 125 MHz. Each TMDS channel is an 8b/10b encoder at 25 MHz, a 10-bit shift register at
  125 MHz that hands two bits per clock to an **ODDR** (DDR = 250 Mbit/s). The N pin gets the inverted bits from a
  second ODDR. The clock pair outputs the 25 MHz pixel clock the same way.
- Every leg goes out as LVCMOS33 with fast slew through a 270 ohm resistor to the HDMI connector.
- Pins: the two stock headers, using real differential pairs so the P/N wires stay together:

| HDMI pin | Signal | Header pin | through |
|---|---|---|---|
| 1 / 3 | data 2 + / - | J6 pin 5 / pin 15 | 270 ohm each |
| 4 / 6 | data 1 + / - | J6 pin 11 / pin 12 | 270 ohm each |
| 7 / 9 | data 0 + / - | J7 pin 5 / pin 15 | 270 ohm each |
| 10 / 12 | clock + / - | J7 pin 11 / pin 12 | 270 ohm each |
| 2, 5, 8, 11, 17 | shields, DDC ground | GND | |
| 18 | +5 V | 5 V through a diode (some monitors need it to wake up) | |

- Keep the wires short (under 10 cm) and twist each pair. A cheap HDMI breakout board makes this easy.
- Risks to test first: whether nextpnr meets 125 MHz for the shift registers and ODDR clocking (our cores reach
  120 to 133 MHz on simpler paths), and whether the monitor accepts the pseudo-differential signal (PicoDVI shows
  most do). If OSERDESE2 gets fixed in the toolchain, switch to it and to TMDS_33.

### What HDMI shows

A console or the BLITTR screen: the same frame buffer in DDR that the network path sends, scanned out at 640 x 480.
Bigger modes need faster pairs (800 x 600 needs 400 Mbit/s, 720p needs 742 Mbit/s), which this ODDR route cannot
reach without a working OSERDESE2.

## Order of work

1. VIZOR shell (done).
2. Step 1: Xvfb + numpy tiles + canvas window (needs the apt OK).
3. HDMI test pattern core (colour bars, no DDR): proves ODDR at 125 MHz and the wiring.
4. BLITTR core (tile checksums + packing), measured against step 1.
5. HDMI scanning the BLITTR frame buffer.
