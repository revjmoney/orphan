#!/bin/bash
# Orphan: the MiSTer C64 core's SID (rtl/sid/*.sv) and CIA (rtl/mos6526.v) for Yosys. Run on the i5 (sv2v there):
#   bash make_sid.sh <C64_MiSTer checkout> <out.v>
# The SID's functions declare their arguments as "wire" (Quartus takes it, sv2v does not): made "input" first.
# by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later.
set -e
SRC=$1; OUT=$2
T=$(mktemp -d)
cp "$SRC"/rtl/sid/*.sv "$T"/
sed -i -E '/^\s*function/ s/([(,]\s*)wire /\1input /g' "$T"/*.sv
${SV2V:-$HOME/tools/sv2v/sv2v-Linux/sv2v} "$T"/*.sv "$SRC"/rtl/mos6526.v -w "$OUT"
rm -rf "$T"
echo "$OUT: $(wc -l < "$OUT") lines, $(grep -c '^module' "$OUT") modules"
