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
| `games/orphan_sms` | Orphan Games: Master System + Game Gear: MiSTer's SMS core GHDL-converted (`vdp_ghdl.v`, `video_ghdl.v`, `T80s_ghdl.v`), jt89 sound, `orphan_sms_block.v` (Sega mapper, frame buffer, stereo, pads); see its `README.md` and `LICENSES.md` |
| `games/sms_vhdl`, `games/ghdl_convert.sh` | the patched VHDL of the SMS core and the GHDL 4 script that turns it into Verilog netlists |
| `games/make_sms_testrom.py` | Orphan's own SMS / Game Gear test cart (`games/smsroms/orphan_test.*`) |
| `games/shared` | the board program and web page every console uses (`main.py` reads the loaded console's ID: NES1/NES2, GB01, SMS1, A261); the page's picture effects and the rules for new cores: [games-picture.md](games-picture.md) |
| `games/sim/tb_nes.v` | loads a ROM through the bus, runs frames, dumps a picture (`nesframe.py` turns it into a PNG) |
| `toys/orphan_toys` | Orphan Graphics Toys (raycast, color waves, XOR, Life) |
| `miners/orphan_btc` | Orphan BTC: a Stratum v1 SHA-256 miner on Ardzy's `13_sha256` core (`stratum_btc.py`, earnings panel, `devfee.py`) |
| `lm/orphan_tinylm` | Orphan TinyLM: `tlm_gemv.v` (64-lane int8 matrix x 4 vectors from DDR), `tlm_pack.py` / `tlm_calib.py` (pack the downloaded models), `main.py` + `index.html` (Write / 4 Stories / Adventure); see its `README.md` |
| `cyd-remote` | ORPHAN Remote: ESP32 CYD firmware (PlatformIO) + the board's display service |
| `orphan/fpga` | blocks every Orphan design includes: `orphan_fan.v` (fans, slot 15, `CLK_HZ` for designs not at 100 MHz), `orphan_leds.v` (LEDs, slot 14) |
| `orphan/add-fan.py`, `orphan/fan-bits` | puts `orphan_fan` into Ardzy's example designs and rebuilds them; the bitstreams the installers use |
| `orphan/devfee.py` | the shared 3 % opt-out dev-fee schedule every Orphan miner uses |
| `orphan/brand-ardzy-web.py`, `orphan/merge-quickstart.py` | the board page in the Orphan look (tree, quick-start popups, GUI auto-open); descriptions + quick starts merged into each `project.json` |

## project.json keys Orphan reads

| Key | Used for |
|---|---|
| `title`, `summary`, `category`, `level` | the menu's and the board page's project pages |
| `quickstart` | a list of short steps: the popup on the board page and the menu's project page |
| `wiring` | a list of `[pin, connect to, note]` |
| `web` | the port of the project's own web page: the board page opens it in a new tab after **Load** |
| `runs` | `fpga core`, `arm linux` or `fpga + arm` (the tag in the menus) |
| `branch` | the tree branch: `games`, `mining`, `science`, `radio & sound`, `lab toys`, `starters & tests` (else taken from `category`) |

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

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM · **[Rev. J. Money - 2026]**
