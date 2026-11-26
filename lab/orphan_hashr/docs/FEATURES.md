# H4SHR-CH3KR: feature and settings log

[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM

## Settings (defaults)

| Setting | Default | Where |
|---|---|---|
| Start voltage | 9.00 V (PIC 74) | `pic.V_START` |
| Voltage window | 8.60 to 9.40 V | `pic.V_MIN`, `pic.V_MAX` |
| Start clock | 400 MHz | `hashr_service.START_MHZ` |
| Clock range | 200 to 650 MHz (bmminer table) | `bm1387.PLL` |
| OFF | 200 MHz, results ignored | `bm1387.OFF_MHZ` |
| Renew timer | 10 min | `hashr_service.TIMER_S` |
| Temperature window | 30 s after DC-DC on | `hashr_service.TEMP_WINDOW_S` |
| Board temperature cutoff | 90 C | `hashr_service.PCB_MAX_C` |
| Fans 100 % | board 75 C or chip 90 C | `FAN_HOT_PCB_C`, `FAN_HOT_CHIP_C` |
| Row balance | 25 % from the board mean | `hashr_service.BALANCE` |
| PIC heartbeat | every 2 s | `hashr_service.HEARTBEAT_S` |
| Chain baud | 115.7 k at start, 1.5625 M after addressing | `BAUD_SLOW`, `BAUD_FAST` |
| Web port | 8000 | `main.PORT` |

## 2026-11-23: phase 1

- FPGA core (slot 1): 9 header UARTs (512-byte TX, 2048-entry RX FIFOs), TX/RST outputs only after GO + EN, raw pin
  levels, 2 byte-level I2C masters (SCL1/SDA1, SCL2/SDA2). 2012 LUT, 9 BRAM, 126.5 MHz (needs 100).
- Service: scan (finds the board on any header), PIC info without power, bring-up in bmminer's order, chain-break
  detection, temperature sensor through the host chip's I2C, per-chip / per-row / all clocks and OFF, row-balance
  check, safety loop.
- Page: tiles, 21 x 3 chip map, chip and row panel, log; Orphan look, fan slider, coffee button.
- Name: H4SHR-CH3KR (Rev). Code name and files: hashr / orphan_hashr, project id HSR1.

## 2026-11-24: stage 1-2, FPGA dispatcher and hashrd (C++)

- FPGA slot 2 (`hr_disp.v`, "HSD1"): 9 chains, each with its own UART, 16-work FIFO, command FIFO, Bitmain pacing
  (`TIMEOUT` us between jobs), 128-entry job table (tag per job id), CRC5 collector that re-syncs on noise; one
  256-entry nonce FIFO for all chains. 105.1 MHz (needs 100), 6243 LUT, 20 BRAM.
- Fan core rules: 20 % while nothing is powered, auto curve 40 to 75 C (20 to 100 %), 10 s temperature watchdog to
  100 %, nothing under 20 %.
- hashrd: bring-up in bmminer's order, baud divider per bmminer (3 at 400 MHz), temperatures via the host chip,
  safety cuts (90 C, 60 s without a temperature, 10 min timer), Bitmain factory pattern test.
- Board test, J6: 63/63 chips pass all 8 patterns at 1179 us pacing, 0.9 s; temperatures and fan curve work.
- Fixed on the board: the PIC heartbeat ran before the PIC was started (now only after `pic.reset`); temperature
  sensor replies carry chip byte 0 and register byte 0, so I2C reads take the one reply in flight like bmminer.
- Known: the 114 warm-up jobs at power-up fill the nonce FIFO with nonces nobody reads (`rx_ovf` counts them); the
  pattern nonces are not affected.


## Stage 3: the FPGA work builder (2026-11-24)

- `hr_build.v` (slot 3 registers, slot 4 two job banks): from a stratum job it builds every work itself: next
  extranonce2 (never repeats within a flip, stalls when it runs out), coinbase double SHA-256 with the padding done in
  hardware, merkle fold over up to 16 branches, header, midstate and tail. One SHA-256 core (`hr_sha.v`, Ardzy's),
  block shifted in a word a clock. 81 us a work for a 300-byte coinbase and 16 branches (9 chains at 400 MHz need
  one every 131 us).
- `hr_disp.v`: CCTRL bit 4 picks the source per chain (ARM or builder); the feeder hands works round-robin to the
  running builder chains (at most 2 queued each), registered once before the 9-chain fanout; a clean flip flushes them.
- hashrd: `builder_test [s]` writes the genesis block as a job, lets the FPGA build and send works, and re-hashes
  every nonce on the ARM (`cpp/work.cpp` rebuilds the work from the nonce's TAG/TAG2).
- Bitstream 104.0 MHz, 9401 LUT, 11050 FF, 21 BRAM. A first build congested (55 MHz estimate): fixed by computing the
  coinbase byte distances once per word, registering the feeder, and dropping the 512-bit block register.
- Board test, J6, 2026-11-24: 200 MHz 9997 valid of 9999 nonces in 30 s (333/s, 0 invalid), 400 MHz 19927 valid
  (664/s, 0 invalid), every chip 136..370; patterns still 63/63. Valid rate = theory (63 x 114 cores x f / 2^32).
- Found on the board: Yosys mapped the word-shift SHA schedule into SRL16Es that hash wrong (RTL right, netlist
  wrong); the chips hashed fine but every nonce was invalid. Fixed with `(* keep *)` on the schedule; new
  `sim/tb_sha.v` + `sim/net_sha.sh` run "abc" on the synthesized netlist so this is caught before the board.
- Review round (fresh reviewer, then Fable): a clean flip in the SHA start clock no longer starts a compression on a
  block never fed; a flush mid-packet no longer lets new works overwrite the slot on the wire; a command flush
  mid-command stops the sender (it used to replay stale commands with wrapped counters); an ARM works flush during
  the feeder's copy drops the copy; e_fits and the nonce ack registered for timing. sim/net_build.sh checks the
  synthesized builder against the known answers and fails on any SRL in our cores. Bitstream 106.8 MHz, 9563 LUT.
  Board, 400 MHz: 19927 valid, 0 invalid, 0 other in 30 s; patterns 63/63.

## Stage 4: the C++ side, Python gone (2026-11-24)

- FPGA keeps the chains on J6, J7, J8 only (`CHAIN_MASK`): 122.1 MHz on the first seed, 5499 LUT (31 %), was a
  5-seed lottery at 9 chains.
- hashrd mines on a pool: stratum v1 (subscribe, authorize, notify, set_difficulty, submit, reconnect with backoff),
  every pool job into the FPGA builder's banks (refused with a reason if the FPGA cannot hold it), every nonce
  re-hashed on the ARM, shares checked against the difficulty in force when their job came, stale and duplicate
  nonces counted, never submitted. 3 % dev fee (97/3 minutes, ledger across restarts, opt-out).
- Up to three boards at once (J6, J7, J8): per-board power, safety and renew timer; the shared GO line and the fan
  only go to "nothing powered" when no board is on; the fan follows the hottest sensor of every board.
- Board controls (PIC info, volts, per-chip / per-row clocks with the 25 % row rule) and every diagnostic (HOLD, DIAG,
  RSTPROBE, KAT, SKOT) in C++.
- The page (port 8000, LAN only) served by hashrd: board picker, every temperature sensor, both fans, network in/out,
  mining (GH/s, valid/invalid/stale, shares accepted/rejected, pool and network difficulty, block, best share).
- The CYD live screen in C++ with DejaVu Sans Mono baked into a bitmap header (changed rows only).
- Every Python file deleted: Ardzy builds and runs hashrd (`Makefile`, `./app`).
- Board test, J6, 2026-11-24, 400 MHz: patterns 63/63; 10 minutes on Mining-Dutch: 46 shares sent, 46 accepted,
  0 rejected, 401270 valid nonces, 0 invalid, about 2.86 TH/s, board 37 C, chip 56 C; DIAG (normal direction answers),
  RSTPROBE (reset = RST low, all 63 answer after a 0-then-1 pulse), HOLD (switched itself off after 15 s), SKOT.
- Found on the board: reading both temperature sensors broke the sensor setup (the I2C reply is read from the current
  host, which was not set yet); the 60 s no-temperature cut powered the board off as designed. Fixed.
