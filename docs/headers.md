# The J headers: who uses which pins

The S9 control board has nine hashboard headers, **J1 to J9** (2 x 9, 2.54 mm). Pins **5, 11, 12 and 15** of each go
straight into the FPGA: **36 general-purpose 3.3 V pins**. The FPGA is reloaded with every project, so the headers
belong to whatever core is loaded. Any project can use any of them.

Stock S9 boards only have **J6, J7 and J8** fitted. For the others, solder a 2 x 9, 2.54 mm pin header into the
footprint. The pins connect straight to the FPGA, so there is nothing to jumper.

## Every header, the same layout

| Pin | What |
|---|---|
| 5, 11, 12, 15 | FPGA I/O, 3.3 V LVCMOS, **not 5 V tolerant**, no protection |
| 16 | 3.3 V out (small loads only) |
| 18 | EN, driven by the ARM side: leave it alone |
| 1, 2, 9, 10, 13, 14 | GND |

- **No pull-ups.** The board has no pull-ups on the four FPGA pins. This was measured 2026-11-22: with weak FPGA
  pull-downs, every pin on J1, J2, J4, J5, J6 and J7 read 0. A design that wants pull-ups sets `PULLTYPE PULLUP` in
  its `pins.xdc`, and an I2C bus on these pins needs its own 3.3 V pull-up resistors.
- **Differential pairs.** On every header except J2, pins **5 and 15** are one FPGA LVDS/TMDS pair (5 = P, 15 = N),
  and pins **11 and 12** are another (11 = P, 12 = N). On J2 only 11/12 is a pair. That matters for HDMI and for the
  radio's comparator input.
- **Check pin 1** with a meter before your first cable: GND on pins 1 and 2.
- The FPGA pin numbers for every header are in [pinmap.md](pinmap.md).

## Who uses what (from each project's `pins.xdc`)

| Project | J1 | J2 | J3 | J4 | J5 | J6 | J7 | J8 | J9 |
|---|---|---|---|---|---|---|---|---|---|
| **[orphan]** Orphan Radio | | | I2S DAC | | | | | antenna in (12), test TX (5), RC feedback (15) | |
| **[orphan]** Orphan Synth | | | I2S DAC | | | | | | |
| **[orphan]** SPEKTOR / INJEKTOR 3000 | any | any | any | any | any | CH0-3 | CH4-7 | CH8-11 | CH12-15 |
| **[orphan]** NES, Game Boy, SMS/GG, Toys, TinyLM, BTC miner | | | | | | | | | |
| [ardzy] 01 LED strip | | | | | | | WS2812 data (5) | | |
| [ardzy] 02 pattern gen | | | | | out 0-3 | out 4-7 | out 8-11 | out 12-15 | |
| [ardzy] 03 encoders | | | | | enc 0-3 | | | | |
| [ardzy] 04 steppers | | | | | | | | step/dir x2 | |
| [ardzy] 05 SPI + I2C | | SPI | | | | | | | |
| [ardzy] 06 signal gen | | | | | par 0-3 | sigma-delta, PWM, sync | | par 4-7 | |
| [ardzy] 07 VGA | | | | | | red, green | | blue, HSYNC, VSYNC | |
| [ardzy] 08 audio | | | I2S DAC | | | I2S in, PDM mic | | | |
| [ardzy] 09 sensors | | | | | | | | trig, echo, IR, touch | |
| [ardzy] 10 RISC-V | | | | | GPIO in | | | GPIO out | |
| [ardzy] 12 FM radio | | | | | | | | | RF in (11) |

SPEKTOR's "any" means its kanal map: each of its 16 channels can sample any of the 36 pins (the defaults are shown).
Its INTERSEKTOR UART bridge (INJEKTOR page) drives two pins, only after GO: by default J7.11 (to device B) and J6.11 (to device A); in on J6.5 and J7.5. Any header pin can be picked instead.
Projects with an empty row use no header pins: their picture, sound and controls go over the network.

## Attachments

### Audio: PCM5102A I2S DAC on J3 (Radio, Synth, Ardzy 08)

| DAC board | Header |
|---|---|
| BCK | J3 pin 11 |
| DIN | J3 pin 12 |
| LCK | J3 pin 15 |
| SCK | J3 pin 5 (the cores send MCLK there), or tie SCK to GND to use the DAC's own PLL. Do one, never both |
| VIN, GND | J3 pin 16 (3.3 V), J3 pin 13 |

Jumpers on the DAC board: FLT = L, DEMP = L, XSMT = H, FMT = L. Full notes: the Radio and Synth READMEs.

### VGA monitor (tested in Ardzy's 07_vga)

640 x 480 at 60 Hz, 2 bits per colour, from 8 resistors and a VGA (DE-15) socket:

| VGA pin | Header |
|---|---|
| 1 red | J6 pin 5 through 470 ohm, J6 pin 11 through 1 kohm |
| 2 green | J6 pin 12 through 470 ohm, J6 pin 15 through 1 kohm |
| 3 blue | J8 pin 5 through 470 ohm, J8 pin 11 through 1 kohm |
| 13 HSYNC | J8 pin 12 through 100 ohm |
| 14 VSYNC | J8 pin 15 through 100 ohm |
| 5, 6, 7, 8, 10 GND | header GND |

The two resistors of a colour join at the VGA pin: a 2-bit DAC into the monitor's 75 ohm input. More colours = more
resistors per colour (and more pins: use J7, J9 or the others).

### HDMI / DVI monitor (planned: not built or tested yet)

The open toolchain's hardware serializer (OSERDESE2) does not work yet, so the plan is the PicoDVI way: fabric shift
registers into ODDR at 125 MHz (250 Mbit/s per pair, 640 x 480 at 60 Hz), every wire driven as plain 3.3 V logic
through a **270 ohm** resistor, P and N with opposite bits. It uses the two stock headers' differential pairs:

| HDMI pin | Signal | Header |
|---|---|---|
| 1 / 3 | data 2 + / - | J6 pin 5 / pin 15, 270 ohm each |
| 4 / 6 | data 1 + / - | J6 pin 11 / pin 12, 270 ohm each |
| 7 / 9 | data 0 + / - | J7 pin 5 / pin 15, 270 ohm each |
| 10 / 12 | clock + / - | J7 pin 11 / pin 12, 270 ohm each |
| 2, 5, 8, 11, 17 | shields, DDC ground | GND |
| 18 | +5 V (some monitors need it to wake up) | a 5 V source through a diode, NOT a header pin |

Use an HDMI breakout board and keep each pair twisted and short (under 10 cm). Status: wiring plan only. The full
design (and why 720p is out of reach this way) is in [orphan/vizor/BLITTR.md](../orphan/vizor/BLITTR.md).

### Radio antennas (Orphan Radio, J8)

The radio samples **J8 pin 12** at 100 MHz with 1 bit. Today it runs with no front end parts (it mostly shows board
noise, see the Radio README). The RC comparator front end gets bench-tested and documented in the Radio README first.
Antennas per band then follow on that front end:

| Band | Antenna |
|---|---|
| VLF / LF (WWVB 60 kHz, longwave) | a tuned loop or a ferrite rod |
| MW (530 to 1700 kHz) | a ferrite loop, or a 10 to 20 m wire with a ground |
| SW (3 to 30 MHz) | a random wire of 10 to 20 m with a 9:1 unun, or an end-fed wire |
| above 30 MHz | use the Network NESDR mode (RTL-SDR on a PC) instead |

Status: plan only until the front end passes its bench test. Never connect an antenna straight to an FPGA pin:
static from a wire antenna can kill the pin.

### Logic probes (SPEKTOR)

The probe builds (ribbon harness, 5 V front end, UART tap, I2C and SPI flash klips, JTAG/SWD leads) are in
SPEKTOR's PROBEZ page and its README.

## Network modes that need no header

- **VIZOR desktop (planned):** a light Orphan desktop in the browser (menu bar, windows for every Orphan tool, a shell).
  No wiring at all: the board serves it over the network.
- **BLITTR (planned):** an FPGA graphics core for VIZOR that streams real Linux apps to the browser (changed tiles
  only). Network only; it can also drive the HDMI attachment above.

---
[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM · [Buy me a coffee](https://buymeacoffee.com/revjmoney)
