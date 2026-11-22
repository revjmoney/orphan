#!/bin/sh
# Turn a board running Ardzy (Debian 13 on the S9 control board) into Orphan. Run ON the board, from a clone:
#   git clone https://github.com/<you>/orphan && cd orphan && sudo sh orphan/setup-board.sh [hostname]
# Installs the Orphan menu, branding and services, adds Orphan Radio + Orphan Synth to the FPGA projects, and
# gives every project a description. Safe to run again (an update). by JMSCNC, makers of RotatoCAM. GPL-3 + attribution.
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
           "$REPO/games/orphan_nes" "$REPO/games-work/orphan_nes" "$REPO/games/orphan_gb" "$REPO/games-work/orphan_gb" "$REPO/toys/orphan_toys" "$REPO/toys-work/orphan_toys"; do
	[ -d "$src" ] || continue
	name=$(basename "$src")
	mkdir -p "$P/$name"
	# runtime data (memories, SSTV pictures, compiled helpers) stays as it is
	( cd "$src" && tar -cf - --exclude=__pycache__ --exclude=memories.json --exclude=sstv . ) | tar -xf - -C "$P/$name"
	echo "project: $name"
done
for f in "$REPO"/orphan/project-meta/*.json; do
	p=$(basename "$f" .json)
	[ -d "$P/$p" ] && cp "$f" "$P/$p/project.json"
done
mkdir -p /opt/orphan-games/roms/nes /opt/orphan-games/roms/gb
echo
echo "Orphan is installed. Log in again (or type: orphan) for the menu."
echo "Projects: $(ls $P | wc -l) in $P. Load one from the menu: F FPGA projects."
