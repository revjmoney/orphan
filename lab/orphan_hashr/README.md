# ORPHAN H4SHR-CH3KR: S9 hashboard tester

[orphan] Test an Antminer S9 hashboard (63 x BM1387) on the S9 control board that was made for it. H4SHR-CH3KR finds
the board, talks to its PIC voltage controller, powers the chain only when you click, counts and addresses the chips,
shows exactly where a chain breaks, reads the board temperatures and lets you clock every chip and every row on its own.

by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.

## Wiring

- The hashboard's ribbon cable on any J header (stock boards have J6, J7 and J8 fitted). The page finds it.
- The hashboard's 12 V from a PSU strong enough for it (one S9 board pulls about 400 W at stock clocks; testing at
  400 MHz pulls far less). The control board can share the supply.
- A fan blowing through the hashboard's heatsinks.

## Use

1. Load `orphan_hashr` (Orphan menu, or `ardzy load orphan_hashr`). Ardzy builds and starts hashrd (`make`, then
   `./app`; the first build takes a few minutes on the ARM). The page is on port 8000.
2. Pick the plug in **Board** (J6, J7 or J8: the stock S9 plugs have a chain; up to three boards can run at once).
   **SCAN** finds the boards. **PIC INFO** reads the PIC (version, board id, voltage). Nothing is powered yet.
3. **POWER ON** (only while you are at the bench). Starts at 9.00 V (8.60 to 9.40 V allowed), switches the DC-DC on,
   counts and addresses the 63 chips, raises the link to 1.5625 Mbaud, starts the temperature readings and clocks every
   chip at 400 MHz. A board with a broken chain shows the chips from the break on in red.
4. Click a chip or a row label: set its clock (200 to 650 MHz) or switch it **OFF** (minimum clock). **SET ALL**
   clocks every chip that is not off.
5. **START MINING** with your pool, wallet / worker and password: the FPGA builds every work from the pool's job, the
   ARM re-hashes every nonce before a share goes out. The page shows GH/s, valid / invalid / stale nonces, accepted and
   rejected shares, the pool's difficulty, the network difficulty and block, the best share, every temperature sensor,
   both fans and the network traffic. The **3 % dev fee** (on by default, untick to switch it off) mines 3 minutes of
   every 100 to the developer's account and shows a DEV FEE SLICE badge while it runs.
6. **TESTS**: PATTERNS (Bitmain's factory test), KAT (genesis header re-hashed), SKOT (Skot's scripts replayed), and
   with the board off DIAG (TX/RX direction and EN), RSTPROBE (reset level) and HOLD (power stage on, chips in reset,
   for measuring the chain voltage).
7. **RENEW TIMER** within 10 minutes or the board powers off by itself. **POWER OFF** when done.

The ORPHAN Remote (CYD) shows the same board live from across the room (orphan-remote.local).

## Chip map

21 rows of 3 chips in chip-address order (chip n = address 4n). Each row is one step of the series voltage chain, so
the chips can't be unpowered one by one, and a row may not run more than 25 % away from the board's average clock
(its share of the voltage would drift). Colors: green answering, red missing or bad, grey off, dim unknown.

## Safety (always on)

- Voltage window 8.60 to 9.40 V (Bitmain's S9 ceiling). A PIC must report version 0x03, or the voltage stays off.
  A PIC is never erased or rewritten.
- Power off: above 90 C board temperature (the hottest sensor); without a temperature reading 60 s after the DC-DC
  switched on; when the renew timer runs out; on any error; when the service stops. The fans follow the hottest
  reading of every powered board. With several boards on, switching one off never touches the others.
- Power-on is never automatic and never saved.

## hashrd (C++, the whole program)

The chains are driven by the FPGA (slot 2, `hr_disp.v`): it sends a job every `TIMEOUT` microseconds like Bitmain's
FPGA (1179 us at 400 MHz), collects and CRC-checks the replies and tags every nonce with its job. hashrd (C++, the
standard library only, no Python) does the rest on the ARM: bring-up, safety, the stratum pool, the dev fee, the page
on port 8000 and the CYD screen. Ardzy runs it as `./app`; the same binary is the command client:

    ./app detect                              # which headers have a board
    ./app power_on 9.40 400 J6                # volts, MHz, plug (only while you are at the bench)
    ./app patterns 8                          # Bitmain's factory test: 8 known works per chip
    ./app mine_start stratum+tcp://pool:port wallet.worker x
    ./app mine_status
    ./app status
    ./app power_off                           # every board (or name one: power_off J6)

Single-board commands take the plug at the end (`set_all 400 J7`); without it they act on the only board that is on.

First run on the eBay board, J6, 2026-11-24: 63 of 63 chips found all 8 patterns, 504 works in 0.9 s, twice in a row;
divider 3 (1.5625 Mbaud class link) at 400 MHz works; temperatures 24 C board, 30 C chip through chip 61.

Fans (slot 15) follow the temperature on their own: 20 % while no board is powered, the 40 to 75 C curve (20 to
100 %) while one is, 100 % if no temperature arrives for 10 s, and nothing under 20 %.

### The work builder (slots 3 and 4)

The FPGA also builds the works itself (`hr_build.v`): C++ writes a stratum job into one of two job banks (slot 4:
header fields, a coinbase template up to 1024 bytes, up to 16 merkle branches, where the extranonce2 goes) and flips
to it; the builder then makes every work on its own: next extranonce2, coinbase double SHA-256 with the padding done in
hardware, the merkle fold, the header, the midstate and the tail, about 81 us a work for a 300-byte coinbase with 16
branches (9 chains at 400 MHz need one every 131 us). Each chain picks its source with CCTRL bit 4: the ARM (the
pattern test) or the builder, which feeds the running builder-mode chains round-robin, at most 2 queued works each.
A clean flip (new block) drops every queued work at once. The extranonce2 never repeats within a flip; when it runs
out the builder stops and counts a stall. Every nonce carries `TAG = {pool tag, en2[47:32]}` and `TAG2 = en2[31:0]`,
so the ARM can rebuild its work and re-hash it (`cpp/work.cpp`, the same model the testbench checks against).

    ./hashrd builder_test 30                  # 30 s of FPGA-built works (the genesis block as a job), every
                                              # nonce re-hashed on the ARM: valid and invalid per second, per chip

On the eBay board, J6, 2026-11-24 (bitstream 104 MHz): at 200 MHz 9997 valid nonces in 30 s (333/s) and none
invalid, at 400 MHz 19927 valid (664/s) and none invalid, every one of the 63 chips finding its share; that is the
whole board's diff-1 rate (63 chips x 114 cores x clock / 2^32).

## Files

| File | What |
|---|---|
| `hashr.v` | FPGA core, slot 1: the 9 headers' EN/RST/SWAP, TX/RST gating, pin levels, 2 I2C masters |
| `top.v`, `pins.xdc` | the design: slot 0 info "HSR1", slot 1 HASHR, slot 2 dispatcher, slots 3 and 4 builder, slot 15 fans |
| `hr_disp.v`, `hr_chain.v`, `hr_crc.v`, `hr_uart.v` | FPGA slot 2: chain dispatchers on J6, J7, J8 (`CHAIN_MASK`), nonce FIFO |
| `hr_build.v`, `hr_sha.v` | FPGA slots 3 and 4: the work builder and its SHA-256 core (Ardzy's) |
| `Makefile`, `index.html` | Ardzy builds and runs hashrd as `./app`; the page it serves |
| `cpp/` | hashrd: bring-up, safety, PIC, BM1387 math, boards J6..J8, stratum, dev fee, miner, page server, CYD screen, diagnostics, tests (`test_*.cpp`) |
| `sim/tb_disp.v`, `sim/tb_build.v`, `sim/tb_fan.v` | self-checking testbenches; `sim/vec/` their known answers (`cpp/test_work vec`) |
| `sim/tb_sha.v`, `sim/net_sha.sh` | SHA-256 "abc" on the RTL and on the synthesized netlist (catches synthesis that differs from the RTL) |

## Coming next

Three boards mining at once on real hardware (the logic is in and tested; one board has been on the bench so far),
and a faster builder for 650 MHz (caching the coinbase midstate before the extranonce2).

## Credits

BM1387 / PIC protocol facts from Bitmain's bmminer (GPL-3.0). The SHA-256 core (`hr_sha.v`) is Ardzy's 13_sha256 lab
(by chryso, GPL-3.0). See NOTICE.
