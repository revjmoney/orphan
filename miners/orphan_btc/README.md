# [orphan] Orphan BTC: a real Stratum SHA-256 miner in the FPGA

**The job the S9 was built for, done by its own control board's FPGA.** Four double-SHA-256 units at 100 MHz
(about 1.1 MH/s) driven by a Stratum v1 client on the ARM. Built on Ardzy's `13_sha256` lab (by chryso, GPL-3.0),
which Orphan turned into a real miner. by [JMSCNC](https://jmscnc.com), makers of RotatoCAM.
[![Buy me a coffee](https://img.shields.io/badge/%E2%98%95%20Buy%20me%20a%20coffee-revjmoney-FFDD00?style=flat)](https://buymeacoffee.com/revjmoney)

## What it does

- Stratum v1: subscribe, authorize, `mining.notify` jobs, `set_difficulty`, `suggest_difficulty`.
- Builds the block header itself: coinbase from coinb1 + extranonce1 + extranonce2 + coinb2, merkle root, version,
  prevhash word order, ntime, nbits; rolls extranonce2 when the 2^32 nonces of a job are used up.
- The FPGA looks for hashes with enough leading zero bits; **every candidate is re-hashed on the ARM and compared to
  the pool's exact share target** before it is sent.
- **Coin & earnings panel:** block height and full reward (subsidy + fees, read from the coinbase), network
  difficulty, the pool's share difficulty, expected shares per hour, expected coins per day, and how long a solo
  block would take. It names the coin by comparing the height with Bitcoin's live tip (mempool.space), so a
  multipool's switching shows. USD value from mempool.space's price when it is Bitcoin.
- Works with any SHA-256 Stratum v1 pool; the username field takes a coin address or a pool account name.

**At 1 MH/s this is a lottery miner.** Use a solo or low-difficulty pool: `stratum+tcp://public-pool.io:21496`
(the default) holds difficulty 1, about one share an hour. The page shows honest numbers.

## 3 % dev fee (on by default, opt-out)

For every 97 minutes mined for you, the miner mines 3 minutes to the developer's pool account (a separate
connection; see `devfee.py`), shows a **DEV FEE SLICE** badge while it runs, and remembers mined time across restarts
so the fee is never skipped or charged twice. Untick **3 % dev fee** in Wallet & pool to turn it off.

## Files

`main.py` (web service, port 8000), `stratum_btc.py` (pool client, header builder, earnings maths), `settings.py`
(stored on the board in `settings.local.json`, never in git), `devfee.py`, `pool_probe.py` (test a pool without
mining), `sha_miner.v` + `top.v` (Ardzy's core + Orphan's fan control), `index.html`.

**[Rev. J. Money - 2026]** · GPL-3.0-or-later (Ardzy parts GPL-3.0)
