# Notice and credits

**Orphan**: FPGA Dev Linux for the S9 Control Board, by JMSCNC, makers of RotatoCAM (jmscnc.com).
Copyright (C) 2026 Rev. J. Money. Licensed under GPL-3.0-or-later with the additional terms in
`ADDITIONAL-TERMS.md`. The monkey logo is not GPL: see `LOGO-LICENSE.md`.

## Built on

| Part | By | License | Source |
|---|---|---|---|
| **Ardzy**: the Debian 13 system for the S9 board, its FPGA toolchain flow, the `ardzy` command, the 25 example and starter projects, `blocks.py` | chryso | GPL-3.0-or-later | https://github.com/chrysovalantischryso/ardzy |
| Linux kernel (Ardzy's 6.18 build) | the Linux developers, Xilinx | GPL-2.0 | https://github.com/Xilinx/linux-xlnx |
| U-Boot (Ardzy's SD card image) | the U-Boot developers | GPL-2.0 | https://source.denx.de/u-boot/u-boot |
| Debian 13 (trixie) | the Debian project | many free licenses (`/usr/share/doc/*/copyright`) | https://www.debian.org |
| Yosys, nextpnr, Project X-Ray (used to build the FPGA designs) | YosysHQ, f4pga | ISC, CC0-1.0 | https://github.com/YosysHQ |
| fpganes: the NES console in `games/orphan_nes/` (cpu, ppu, apu, mmu, nes, MicroCode, compat .v) | Ludvig Strigeus | GPL-2.0 (`games/orphan_nes/COPYING-fpganes`) | https://github.com/strigeus/fpganes |
| VerilogBoy: the Game Boy in `games/orphan_gb/` (boy, cpu, ppu, sound, timer, dma ... .v) | Wenting Zhang (zephray) | Open Hardware Description License 1.0 (`games/orphan_gb/LICENSE-VerilogBoy-OHDL`) | https://github.com/zephray/VerilogBoy |
| LovyanGFX, ArduinoJson (ORPHAN Remote firmware, fetched by PlatformIO) | lovyan03, Benoit Blanchon | FreeBSD/BSD-2, MIT | PlatformIO registry |

The NES project is licensed **GPL-2.0-or-later** as a whole (Orphan's own files in it, including the copies of
`orphan_fan.v` and `orphan_leds.v`, are also offered under GPL-2.0-or-later), so it can be built together with
fpganes. Orphan's changes to fpganes are marked "(Orphan: ...)" in its files.

The Game Boy project uses Orphan's own boot ROM (`games/make_gb_bootrom.py`, 40 bytes that only set up the CPU and
the chips); Nintendo's boot ROM is not used or needed. Changed VerilogBoy files carry a dated "Modified for Orphan
Games" line.

Games: no ROM files are in this repository. Use free homebrew whose license allows it; put `.nes` files in
`/opt/orphan-games/roms/nes` and `.gb` files in `/opt/orphan-games/roms/gb` on the board.

Orphan is an add-on: it does not change Ardzy's own files, it installs next to them. Ardzy's third-party list
(`THIRD_PARTY_NOTICES.md` in Ardzy) covers everything inside Ardzy's SD image.

## Research credit

The S9 control board was mapped with help from public work by polprog (antminer_zynq), astranome (Astra_S9_FPGA)
and Braiins (zynq-io, Braiins OS docs). `tools/fetch_sources.sh` clones them for reference; none of their files
are copied into this repository.

## Not included, on purpose

- No Bitmain software, firmware, FPGA bitstream or schematic is in this repository.
- The flash install (`flash-build/`) reuses the boot loader **already in your own board's flash**: it reads it from
  your board; it is never shipped.
- The mining FPGA design is not included or needed.
