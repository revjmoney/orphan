#!/bin/sh
# Turn a board running Ardzy (Debian 13 on the S9 control board) into Orphan. Run ON the board, from a clone:
#   git clone https://github.com/revjmoney/orphan && cd orphan && sudo sh orphan/setup-board.sh [hostname]
# Installs the Orphan menu, branding and services, adds Orphan's own FPGA projects (radio, synth, NES, Game Boy,
# Master System / Game Gear, toys, BTC miner, TinyLM), puts fan control into Ardzy's examples, and gives every
# project a description and a quick start. Safe to run again (an update). by JMSCNC, makers of RotatoCAM. GPL-3 + attribution.
set -e
REPO=$(cd "$(dirname "$0")/.." && pwd)
P=/opt/ardzy/projects
[ -d "$P" ] || { echo "No $P here: this needs a board running Ardzy (see the README, Getting started)."; exit 1; }
sh "$REPO/orphan/install.sh" "" "${1:-}"
if [ -n "${1:-}" ]; then
	# Ardzy re-applies the hostname from /boot/ardzy.txt at every boot: set it there too, and now
	if [ -f /boot/ardzy.txt ]; then
		if grep -q '^hostname' /boot/ardzy.txt; then sed -i "s/^hostname.*/hostname  = $1/" /boot/ardzy.txt
		else printf 'hostname  = %s\n' "$1" >> /boot/ardzy.txt; fi
	fi
	hostnamectl set-hostname "$1" 2>/dev/null || hostname "$1"
	systemctl restart avahi-daemon 2>/dev/null || true
fi
for src in "$REPO/radio/orphan_radio" "$REPO/radio-work/orphan_radio" "$REPO/synth/orphan_synth" "$REPO/synth-work/orphan_synth" \
           "$REPO/games/orphan_nes" "$REPO/games-work/orphan_nes" "$REPO/games/orphan_gb" "$REPO/games-work/orphan_gb" "$REPO/games/orphan_sms" "$REPO/games-work/orphan_sms" "$REPO/toys/orphan_toys" "$REPO/toys-work/orphan_toys" "$REPO/miners/orphan_btc" "$REPO/miners-work/orphan_btc"            "$REPO/lm/orphan_tinylm" "$REPO/lm-work/orphan_tinylm"; do
	[ -d "$src" ] || continue
	name=$(basename "$src")
	mkdir -p "$P/$name"
	# runtime data (memories, SSTV pictures, compiled helpers) stays as it is
	# (a board's own miner settings, dev-fee ledgers and language-model weights stay as they are)
	( cd "$src" && tar -cf - --exclude=__pycache__ --exclude=memories.json --exclude=sstv --exclude='*.local.json' --exclude=model . ) | tar -xf - -C "$P/$name"
	echo "project: $name"
done
for f in "$REPO"/orphan/project-meta/*.json; do
	p=$(basename "$f" .json)
	[ -d "$P/$p" ] && cp "$f" "$P/$p/project.json"
done
# descriptions + quick starts merged into every project.json; fan control in Ardzy's example designs
python3 "$REPO/orphan/merge-quickstart.py" "$REPO"/orphan/project-meta/quickstart*.json
for f in "$REPO"/orphan/fan-bits/*.bit; do [ -f "$f" ] || continue; n=$(basename "$f" .bit); [ -d "$P/$n" ] && cp "$f" "$P/$n/$n.bit"; done
W=/opt/ardzy/web   # Ardzy's web page in the Orphan look ("Ardzy inside"); the original stays as index.ardzy.html
if [ -f $W/index.html ]; then [ -f $W/index.ardzy.html ] || cp $W/index.html $W/index.ardzy.html; python3 "$REPO/orphan/brand-ardzy-web.py" $W/index.ardzy.html $W/index.html; fi
mkdir -p /opt/orphan-games/roms/nes /opt/orphan-games/roms/gb /opt/orphan-games/roms/sms
echo
echo "Orphan is installed. Log in again (or type: orphan) for the menu."
echo "Projects: $(ls $P | wc -l) in $P. Load one from the menu: F FPGA projects."
[ -f "$P/orphan_tinylm/model/stories15M.npz" ] || echo "Orphan TinyLM needs its model files: see lm/orphan_tinylm/README.md (tlm_pack.py on a PC)."
