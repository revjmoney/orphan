# FPGA projects

A project is a folder in `/opt/ardzy/projects/<name>` on the board (Ardzy's format): an FPGA bitstream (`.bit`),
an optional program that runs after it loads (`main.py`, a C program, a sketch or `run.sh`), and `project.json`
(title, summary, wiring) that the Orphan menu shows. Load one from the menu (**F**) or with `ardzy load <name>`;
`ardzy load <name> --default` also loads it at every boot.

## Orphan's projects in this repository

| Folder | Project |
|---|---|
| `radio/orphan_radio` | Orphan Radio: FPGA core `orphan_radio.v`, board DSP `rxd.c`, web server `main.py`, panel `index.html` |
| `radio/sim` | Icarus Verilog testbenches and test-signal generators (CW, NAVTEX, WWVB, SSTV) |
| `synth/orphan_synth` | Orphan Synth: FPGA core `orphan_synth.v`, effects daemon `fxd.c`, `main.py`, `term.py`, panel |
| `games/orphan_nes` | Orphan Games: fpganes (GPL-2) in `orphan_nes_block.v` (cart RAM, frame buffer, sound, pads), `main.py`, `index.html` |
| `games/orphan_gb` | Orphan Games: VerilogBoy (OHDL) in `orphan_gb_block.v` (cart + mapper, frame buffer, stereo sound, pads); `brom.v` is Orphan's own boot ROM (`make_gb_bootrom.py`) |
| `games/shared` | the board program and web page both consoles use (`main.py` reads the loaded console's ID) |
| `games/sim/tb_nes.v` | loads a ROM through the bus, runs frames, dumps a picture (`nesframe.py` turns it into a PNG) |
| `toys/orphan_toys` | Orphan Graphics Toys (raycast, color waves, XOR, Life) |
| `cyd-remote` | ORPHAN Remote: ESP32 CYD firmware (PlatformIO) + the board's display service |
| `orphan/fpga` | blocks every Orphan design includes: `orphan_fan.v` (fans, slot 15), `orphan_leds.v` (LEDs, slot 14) |

## Building a design (no Vivado)

The designs build with Ardzy's open toolchain flow (Yosys + nextpnr + Project X-Ray), on a Windows or Linux PC:

```sh
bash tools/fetch_sources.sh          # clones Ardzy (and reference projects) next to this repo's files
cd radio
python build.py orphan_radio         # about 5 minutes; writes orphan_radio/orphan_radio.bit
bash deploy.sh <board ip>            # copies the project to the board and loads it
```

`ARDZY_PC_APP` can point at another copy of Ardzy's `pc_app`. The build prints the resources used and the
maximum clock; Orphan's designs must pass **100 MHz**.

Simulate before building, for example:

```sh
cd radio
iverilog -g2005 -o sim/m.out sim/tb_multi.v orphan_radio/orphan_radio.v ../ardzy/pc_app/fpga/hdl/ardzy_sine_rom.v
vvp sim/m.out
```

## Rules for new designs

- Include `orphan_fan` (slot 15) so the fans stay controllable, and use `orphan_leds` (slot 14) for D5..D8.
- Every register block sits in a 4 KB slot of Ardzy's bus at `0x43C0_0000 + slot * 0x1000`; slot 0 is the
  info block (project ID).
- Keep every path short enough for 100 MHz: register between steps instead of chaining adders and compares.
