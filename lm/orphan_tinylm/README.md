# [orphan] Orphan TinyLM: retired silicon writes stories

**Real Llama language models running on the FPGA of an Antminer S9 control board.** Karpathy's `stories15M` and
`stories42M` (llama2.c, MIT, trained on TinyStories): every matrix product runs in the FPGA, 8-bit weights streamed
from DDR into **64 multiply lanes**, up to **4 stories in one weight pass**. The ARM does attention, RMSNorm, RoPE and
picks the words. by [JMSCNC](https://jmscnc.com), makers of RotatoCAM.
[![Buy me a coffee](https://img.shields.io/badge/%E2%98%95%20Buy%20me%20a%20coffee-revjmoney-FFDD00?style=flat)](https://buymeacoffee.com/revjmoney)

## Modes (web page on port 8000)

- **Write:** one story from your opening.
- **4 Stories:** four different stories from the same opening, computed together.
- **Adventure:** choose your own adventure. The FPGA writes **4 takes of the next chapter** at once; press
  *Pick this* and the story continues from your choice (its memory is copied to all four slots, nothing is re-read).
- **Model:** Stories 15M (fast) or Stories 42M (better stories). Both sit in DDR at once, so switching is instant.
- **Race:** 1 story on the FPGA, 4 at once on the FPGA, and the ARM alone (numpy, same integers).

Measured on the board (stories15M): one story about 11 words/s; the FPGA matches the ARM's integer math exactly
(startup self-check, max difference 0).

## Getting the models (not in this repository)

The weights are downloaded and packed on a PC (Python 3 + numpy):

```powershell
mkdir tinylm-data; cd tinylm-data
curl -LO https://huggingface.co/karpathy/tinyllamas/resolve/main/stories15M.bin
curl -LO https://huggingface.co/karpathy/tinyllamas/resolve/main/stories42M.bin
curl -LO https://raw.githubusercontent.com/karpathy/llama2.c/master/tokenizer.bin
cd ../lm/orphan_tinylm
py -3 tlm_pack.py ../../tinylm-data model stories15M
py -3 tlm_pack.py ../../tinylm-data model stories42M
py -3 tlm_calib.py ../../tinylm-data stories15M
py -3 tlm_calib.py ../../tinylm-data stories42M
scp -r model root@orphan.local:/opt/ardzy/projects/orphan_tinylm/
```

`tlm_pack.py` quantizes every matrix to int8 (one scale per row) and lays the bytes out exactly as the engine streams
them (per HP port, per group of 16 rows, per column: 8 bytes). `tlm_calib.py` picks a right-shift per matrix so the
batch engine's 16-bit results fit, and prints sample stories with that rounding.

## How it works

| File | What |
|---|---|
| `tlm_gemv.v` | The engine: 64 lanes (16 rows x 4 stories), two DDR streamers (HP0 + HP2) with a 16384-page table (64 MB), x in block RAM, 16-bit saturated results in two banks |
| `top.v`, `pins.xdc` | 75 MHz (like Ardzy's AI Studio), fan control in slot 15 |
| `tlm_board.py` | DDR store (locked memory + physical pages), HP0 64-bit fix, readback by single-address gathers |
| `tlm_batch.py` | The 4-slot Llama runner and the batch engine driver |
| `tinylm.py` | Model loader, tokenizer, the float and int8 reference (numpy) |
| `main.py`, `index.html` | The story server and page |

Three things found on the hardware, worth knowing for any S9 DDR design:
- **HP0 boots in 32-bit mode** (the S9's boot firmware sets AFI `RDCHAN_CTRL` bit 0): the upper half of every 64-bit
  word reads 0. `tlm_board.set_hp0_64bit()` clears it with one 32-bit write (byte access to that block faults).
- **Burst reads of a pop window scramble** through the bus bridge at 75 MHz: read results by gathering the same
  address with single 32-bit loads.
- A FIFO cleared on the edge the state machine enters RUN can hand it a stale word: wait one clock (`S_GO`).

## Credits

Models and tokenizer: [llama2.c](https://github.com/karpathy/llama2.c) by Andrej Karpathy (MIT); TinyStories by
Ronen Eldan and Yuanzhi Li. DDR streamers, page table and FIFO: Ardzy's AI Studio `mlp_ddr` (by chryso, GPL-3.0).
This project: GPL-3.0-or-later. **[Rev. J. Money - 2026]**
