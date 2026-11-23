# Join in: make Orphan better

Orphan turns a retired Antminer S9 control board into a hacker's FPGA computer, and there are millions of these boards
sitting in drawers. Everything here is open, and **everyone is welcome**: you don't need to be an FPGA wizard.

[![Buy me a coffee](https://img.shields.io/badge/%E2%98%95-Buy%20me%20a%20coffee-ffcc2e)](https://buymeacoffee.com/revjmoney)

## Ways to help

| | |
|---|---|
| **Report a bug** | something broke, a page looks wrong, a core misbehaves: [open a bug report](../../issues/new?template=bug.yml) |
| **FPGA modules** | a new core or a block other cores can use (a UART, a video output, a sensor, a soft CPU, a DSP block, a miner): [propose an FPGA module](../../issues/new?template=fpga-module.yml) |
| **Plugins** | SPEKTOR dekoders, INJEKTOR modules, VIZOR windows, MIMIK chip models (`lab/orphan_mimik/models/`: a model.json, plus a model.py for sensors): [propose a plugin](../../issues/new?template=plugin.yml) |
| **Anything you want to run** | "could the S9 do X?": [ask for a feature](../../issues/new?template=feature.yml) |
| **The README and the website** | clearer words, better screenshots, translations, how-tos, wiring photos |
| **Theming** | the lime / matrix look across the pages, VIZOR, the X desktop, the terminal menu, the boot art |
| **Hardware** | probe and attachment builds, wiring photos, adapter boards, cases, fan mounts |
| **Testing** | other S9 board revisions, other SD cards, PulseView / GTKWave on the X desktop, odd network setups |

Good first steps are labelled **good first issue**.

## How to send a change

1. Fork the repo and make a branch.
2. Keep to the house style (below).
3. Test it on a real board if you can, and say how you tested it in the pull request (or what you couldn't test).
4. Open a pull request. Small and focused is easier to review than one huge change.

### FPGA cores

- Start from an existing Orphan core (`lab/orphan_spektor` is a good model): `top.v`, `pins.xdc`, your block on
  `ardzy_bus` slot 1 and up, `ardzy_info` on slot 0, and **`orphan_fan` on slot 15** (every Orphan design keeps the
  fans working).
- Build with `py -3 games/build.py <your project dir>` (Yosys + nextpnr, no Vivado). It must meet 100 MHz.
- Known toolchain limits: OSERDESE2 does not toggle; ODDR, MMCM/PLL, BRAM, DSP work (see `docs/projects.md`).
- Add a `project.json` with a `branch` (games, mining, science, radio & sound, lab toys, starters & tests, etc.), a
  `summary` and a `quickstart`, so it shows up in the menu tree, VIZOR's KORES window and the board page.
- Say which header pins it uses (update `docs/headers.md`).

### Web pages

- Plain HTML, CSS and JavaScript, no build step. Match the Orphan look: dark background, lime `#d2ff51`, the 0/1 rain
  canvas (with the FX on/off switch), translucent cards.
- Every page keeps the coffee button and the `<span id="orphan-fan"></span>` fan slider in its header, and the
  footer credit line.

### House style

- Credit line on pages and in READMEs: **[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM**. Keep the
  existing credits, add your name in `NOTICE.md`.
- Plain, short words in docs. No em dashes.
- Never commit secrets, wallets other than the dev-fee ones already in the code, ROMs or model weights.
- Miners keep the 3 % opt-out dev fee and say so on their page.
- Free / homebrew content only: no commercial ROMs, no Bitmain firmware or bitstreams.

## Licence

Orphan is GPL-3.0 with attribution terms (`ADDITIONAL-TERMS.md`). By sending a change you agree it is released under
the same licence. The monkey logo is not under the GPL (`LOGO-LICENSE.md`). "Orphan", "JMSCNC" and "RotatoCAM" are
trademarks: forks must rebrand.

Questions? Open an issue. Thanks for helping these boards live a second life.

---
[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM · [Buy me a coffee](https://buymeacoffee.com/revjmoney)
