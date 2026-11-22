# [orphan] Orphan Games: Master System + Game Gear in the FPGA

The Sega Master System and Game Gear rebuilt in the S9 control board's FPGA: the T80 Z80, the SMS VDP and video
timing, and the SN76489 sound chip (jt89) as hardware, on Orphan's shared games page (port 8000). Carts up to 128 KB
with the Sega mapper; `.gg` files switch the core into Game Gear mode (160 x 144, 12-bit colour, stereo sound).
by [JMSCNC](https://jmscnc.com), makers of RotatoCAM.
[![Buy me a coffee](https://img.shields.io/badge/%E2%98%95%20Buy%20me%20a%20coffee-revjmoney-FFDD00?style=flat)](https://buymeacoffee.com/revjmoney)

## The GHDL route

MiSTer's SMS core is VHDL; the open toolchain here (Yosys + nextpnr) reads Verilog. GHDL 4.1 (`ghdl-mcode`) turns
the VHDL into plain Verilog netlists: `games/ghdl_convert.sh <folder> <top> ...`. The VHDL needed a few fixes for
GHDL (patched copies in `games/sms_vhdl`: `entity work.x` instantiation, explicit vector widths, a `with/select` as a
process, an own `dpram.vhd` instead of Quartus' altsyncram). Two fixes for the Zynq tools: GHDL's backslash names are
renamed, and jt89's falling-edge clock enable is the same signal made combinationally (marked in `jt89.v`).

Clock 53.714 MHz (MMCM 100 x 11.75 / 21.875) with clock enables like MiSTer's: Z80 and PSG /15, VDP /5, pixels /10.
4460 LUT, 52 of 60 block RAMs.

## Test cart

`games/make_sms_testrom.py` writes Orphan's own test program (16 colour tiles scrolling, a tone that follows the
pad) as `orphan_test.sms` and `orphan_test.gg`: no download needed for a first check. Free homebrew from
[SMS Power](https://www.smspower.org/Homebrew/Index) goes in `/opt/orphan-games/roms/sms`.

Licences: see `LICENSES.md` (MiSTer SMS GPL-2.0-or-later, T80 BSD-style with its notice kept, jt89 GPL-3.0,
Orphan's glue GPL-3.0-or-later). **[Rev. J. Money - 2026]**
