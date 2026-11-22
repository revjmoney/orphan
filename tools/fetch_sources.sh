#!/usr/bin/env bash
# Re-clone the public third-party repos used for this research, at the commits checked on 2026-11-19.
# They are git-ignored here; run from the repo root.
set -e
clone() { # url dir commit
  [ -d "$2" ] || git clone -q "$1" "$2"
  git -C "$2" checkout -q "$3" 2>/dev/null || echo "note: $2 could not check out $3 (shallow or moved), left at its default branch"
}
clone https://github.com/chrysovalantischryso/ardzy.git ardzy 97f38ac
clone https://github.com/astranome/Astra_S9_FPGA.git Astra_S9_FPGA 01ff7e2
clone https://github.com/polprog/antminer_zynq.git antminer_zynq 1dc1ee7
clone https://github.com/braiins/zynq-io.git zynq-io 7f8e9a5
clone https://github.com/tgr-braiins/braiins-os-docs.git bos-docs HEAD
mkdir -p zips
unzip -qo antminer_zynq/Antminer_s9_pynq-main.zip -d zips/pynq
unzip -qo antminer_zynq/S9miner_sample-master.zip -d zips/sample
echo done
# game console cores (Orphan Games)
mkdir -p third_party
clone https://github.com/strigeus/fpganes.git third_party/fpganes HEAD
clone https://github.com/zephray/VerilogBoy.git third_party/VerilogBoy HEAD
clone https://github.com/lawrie/nes_ecp5.git third_party/nes_ecp5 HEAD
