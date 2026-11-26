#!/bin/sh
# [orphan] H4SHR-CH3KR: synthesize hr_sha.v the way the Ardzy flow does (synth_xilinx -flatten -abc9) and run
# sim/tb_sha.v on the netlist with Yosys's Xilinx cell models. Catches synthesis that differs from the RTL.
# Usage (from lab-work/orphan_hashr): sh sim/net_sha.sh [ardzy fpga tools dir]
# by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
set -e
T=${1:-../../ardzy/pc_app/tools/fpga}
"$T/bin/yosys" -q -p "read_verilog hr_sha.v; synth_xilinx -flatten -abc9 -arch xc7 -top hr_sha256; write_verilog -noattr sim/sha_net.v"
iverilog -g2012 -o sim/tb_sha_net.vvp sim/tb_sha.v sim/sha_net.v "$T/share/yosys/xilinx/cells_sim.v"
vvp -n sim/tb_sha_net.vvp
rm -f sim/sha_net.v sim/tb_sha_net.vvp
