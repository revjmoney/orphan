# MIMIK: the Orphan chip emulator (design)

**Status: design (2026-11-22).** `[orphan] orphan_mimik`, branch `science`. Part of the ORPHAN LOGIC LAB family next
to SPEKTOR / INJEKTOR. Name in the K style: **MIMIK** (it mimics a chip).

[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM · GPL-3.0-or-later

## What it does

Plug the S9 into a dead or missing chip's place (a ROM socket, an I2C or SPI device's pads, a bus) and the FPGA
answers **as that chip**, live, at the chip's speed. For repair (a dead EPROM in an arcade board, a missing EEPROM),
reverse engineering (a fake sensor that returns what you want), and development (a device that does not exist yet).

## Chip models are plugins

A **chip model** is a small folder anyone can write and send in a pull request:

```
mimik/models/24c02/
  model.json        name, bus, pins, timing, size, description, author, licence
  model.py          optional: behaviour on the ARM (registers, side effects) for slow buses
  image.bin         optional: the contents (ROM / EEPROM / register file)
  README.md         wiring, what is tested
```

`model.json` picks one of the FPGA **bus engines** below and fills in its parameters, so most chips need no Verilog:

| Bus engine | Covers | Speed |
|---|---|---|
| **parallel ROM / SRAM** | 27C64..27C512 EPROMs, 6116/6264 SRAM, Flash in read mode: address in, data out after the chip's access time | answers in < 20 ns from the FPGA's block RAM (64 KB) or DDR |
| **I2C target** | 24Cxx EEPROMs, sensors (BME280, MPU-6050 style), RTCs, IO expanders, PMIC registers | 100 kHz / 400 kHz / 1 MHz, clock stretching |
| **SPI target** | 25xx SPI flash (READ, FAST READ, JEDEC ID, status, write enable, page program), SPI sensors, shift registers | up to ~25 MHz |
| **UART device** | GPS modules (NMEA), modems (AT commands, the LFD3K-SM), console devices | any baud |
| **1-Wire** | DS18B20, DS2431 | standard / overdrive |
| **custom** | a plugin brings its own Verilog block for the free slot (with `model.json` describing its registers) | |

Register-style chips (sensors) are a register file in BRAM that the FPGA serves instantly, while `model.py` on the
ARM updates values over time (a fake temperature ramp, an accelerometer playing back a recording).

## Pins and levels

- 36 header pins, mapped per model like SPEKTOR's kanal map. A parallel ROM needs up to 16 address + 8 data + /CE /OE
  = 26 pins: J1..J9 minus the fan block, so it fits.
- **3.3 V only on the FPGA side.** For 5 V targets (most EPROM sockets) a level adapter board:
  74LVC245 (5 V tolerant inputs) for address lines in, and 74HCT245 / 74AHCT245 (powered at 5 V, 3.3 V-friendly
  inputs) for the data lines out, with /OE from the target's /OE so we only drive when read. A DIP-28 adapter
  plug into the target's socket. Build pages for it in the page like SPEKTOR's PROBEZ.

## The page

KHIPZ (load a model, see the pins it uses), SOKKET (the wiring with drawings), LIVE (every access as it happens:
address, data, read/write, a hit map of which addresses the target reads), IMAGE (load / save / hex-edit the
contents), plus the Orphan header (coffee, fan slider) and a terminal drawer. SPEKTOR can record the same bus in a
second board for proof.

## Build order

1. I2C target engine + the 24C02 model (simplest: test it with the board's own I2C bus on a loopback wire).
2. SPI flash engine + the 25Q32 model (test: a Raspberry Pi or flashrom reads it).
3. Parallel ROM engine + the 27C256 model + the 5 V adapter (test: a Z80 / 6502 board boots from it).
4. The plugin loader (model.json), the page, the CONTRIBUTING section "write a chip model".
5. UART and 1-Wire engines.
