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
| MiSTer SMS core: the Master System / Game Gear VDP and video timing in `games/orphan_sms/` (VHDL in `games/sms_vhdl/`, GHDL-converted to `*_ghdl.v`) | Sorgelig and the MiSTer developers (from earlier SMS cores) | GPL-2.0-or-later (`games/orphan_sms/LICENSES.md`) | https://github.com/MiSTer-devel/SMS_MiSTer |
| T80: the Z80 CPU in the Master System core (`games/sms_vhdl/T80/`, `T80s_ghdl.v`) | Daniel Wallner, MikeJ, TobiFlex, Sorgelig | BSD-style; its notice is kept in the source and at the top of the synthesized `T80s_ghdl.v` | https://github.com/MiSTer-devel/SMS_MiSTer |
| jt89: the SN76489 sound chip (`games/orphan_sms/jt89*.v`) | Jose Tejada | GPL-3.0-or-later | https://github.com/jotego/jt89 |
| GHDL (used to turn the SMS core's VHDL into Verilog) | Tristan Gingold and contributors | GPL-2.0-or-later | https://github.com/ghdl/ghdl |
| Orphan BTC's SHA-256 core (`miners/orphan_btc/sha_miner.v`, `blocks.py`, `sha256_model.py`): Ardzy's `13_sha256` lab, turned into a Stratum miner by Orphan | chryso | GPL-3.0 | https://github.com/chrysovalantischryso/ardzy |
| Orphan TinyLM's DDR streamers, page table and FIFO (`lm/orphan_tinylm/tlm_gemv.v`): from Ardzy's AI Studio `mlp_ddr` | chryso | GPL-3.0 | https://github.com/chrysovalantischryso/ardzy |
| stories15M, stories42M and the tokenizer (downloaded by you, not in this repository; see `lm/orphan_tinylm/README.md`) | Andrej Karpathy (llama2.c); TinyStories by Ronen Eldan and Yuanzhi Li | MIT (models, llama2.c); TinyStories CDLA-Sharing-1.0 | https://github.com/karpathy/llama2.c |
| LovyanGFX, ArduinoJson (ORPHAN Remote firmware, fetched by PlatformIO) | lovyan03, Benoit Blanchon | FreeBSD/BSD-2, MIT | PlatformIO registry |

The NES project is licensed **GPL-2.0-or-later** as a whole (Orphan's own files in it, including the copies of
`orphan_fan.v` and `orphan_leds.v`, are also offered under GPL-2.0-or-later), so it can be built together with
fpganes. Orphan's changes to fpganes are marked "(Orphan: ...)" in its files.

The Game Boy project uses Orphan's own boot ROM (`games/make_gb_bootrom.py`, 40 bytes that only set up the CPU and
the chips); Nintendo's boot ROM is not used or needed. Changed VerilogBoy files carry a dated "Modified for Orphan
Games" line.

The Master System project combines GPL-2.0-or-later (MiSTer SMS), BSD-style (T80) and GPL-3.0-or-later (jt89,
Orphan) parts; as a whole it is distributed under GPL-3.0-or-later. Orphan's own test cart
(`games/make_sms_testrom.py`) is the only SMS program in this repository.

Games: no game ROM files are in this repository. Use free homebrew whose license allows it; put `.nes` files in
`/opt/orphan-games/roms/nes`, `.gb` files in `/opt/orphan-games/roms/gb` and `.sms` / `.gg` files in
`/opt/orphan-games/roms/sms` on the board.

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
- Bitmain's mining FPGA design is not included or needed. (Orphan BTC is Orphan's own miner, built on Ardzy's
  open SHA-256 lab.)
- No language-model weights: they are downloaded from their authors and packed on your PC.

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM ·
**[Rev. J. Money - 2026]**
