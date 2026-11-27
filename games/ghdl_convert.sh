#!/bin/bash
# VHDL cores -> Verilog netlists for Ardzy's Yosys flow (which reads Verilog only), with GHDL's synthesis.
# Run on a Linux PC with GHDL 4 (mcode backend works without LLVM):
#   bash ghdl_convert.sh <folder with .vhd files> <top entity> [<top entity> ...]
#   (GHDL_STD=93c for older cores whose aggregates are ambiguous in VHDL-2008)
# Writes <top>_ghdl.v next to the sources: one plain Verilog module tree per top, generics fixed to defaults.
# by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later.
set -e
G=${GHDL:-$(command -v ghdl-mcode || command -v ghdl)}
DIR=$1; shift
cd "$DIR"
rm -rf .ghdl && mkdir .ghdl
find . -name '*.vhd' -not -path './.ghdl/*' | sort > .ghdl/files
$G -i --std=${GHDL_STD:-08} -fsynopsys -frelaxed --workdir=.ghdl $(cat .ghdl/files) 2>&1 | grep -iv warning || true
for top in "$@"; do
    $G -m --std=${GHDL_STD:-08} -fsynopsys -frelaxed --workdir=.ghdl "$top" 2>&1 | grep -iv warning | head -20 || true
    $G synth --std=${GHDL_STD:-08} -fsynopsys -frelaxed --workdir=.ghdl --out=verilog "$top" > "${top}_ghdl.v" 2> ".ghdl/$top.err" || {
        echo "== $top FAILED"; grep -i error ".ghdl/$top.err" | head -20; exit 1; }
    echo "== $top: $(wc -l < "${top}_ghdl.v") lines, $(grep -c '^module' "${top}_ghdl.v") modules"
done
