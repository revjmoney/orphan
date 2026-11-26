#!/bin/sh
# [orphan] H4SHR-CH3KR: the work builder as synthesized (hr_build + hr_sha, synth_xilinx -flatten -abc9 like the
# Ardzy flow) against tb_build's first three known answers (genesis, big: 16 branches and an en2 straddle, pad: an
# extra padding block). -nobram: Yosys's Xilinx cell models have no block RAM, so the job memory goes to LUT RAM
# here; everything else is the logic the bitstream gets. Catches synthesis that differs from the RTL (2026-11-24:
# the SRL16E message schedule). Then synthesizes the dispatcher with its chains and fails on any SRL in our cores
# (the Ardzy flow has no -nosrl; the one SRL in the bitstream is Ardzy's own reset synchronizer).
# A few minutes. Usage (from lab-work/orphan_hashr): sh sim/net_build.sh [tools dir]
# by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
set -e
T=${1:-../../ardzy/pc_app/tools/fpga}
"$T/bin/yosys" -q -p "read_verilog hr_disp.v hr_chain.v hr_crc.v hr_uart.v; synth_xilinx -flatten -abc9 -arch xc7 -top hr_disp; tee -q -o sim/srl_disp.txt stat"
"$T/bin/yosys" -q -p "read_verilog hr_build.v hr_sha.v; synth_xilinx -flatten -abc9 -nobram -arch xc7 -top hr_build; tee -q -o sim/srl_build.txt stat; write_verilog -noattr sim/build_net.v"
n=$(cat sim/srl_disp.txt sim/srl_build.txt | grep -c "SRL" || true)
rm -f sim/srl_disp.txt sim/srl_build.txt
if [ "$n" != "0" ]; then echo "FAIL srl_check ($n SRL lines in hr_disp/hr_chain/hr_build/hr_sha)"; else echo "ok   srl_check (no SRL in our cores)"; fi
iverilog -g2012 -DNETLIST -o sim/tb_build_net.vvp sim/tb_build.v sim/build_net.v "$T/share/yosys/xilinx/cells_sim.v"
vvp -n sim/tb_build_net.vvp | grep -v finish
rm -f sim/build_net.v sim/tb_build_net.vvp
