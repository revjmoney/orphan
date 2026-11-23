#!/bin/bash
# Make every Orphan board run the same software: the Orphan menu/branding and the same FPGA project set,
# with descriptions. Run from the PC (Git Bash):   bash orphan/sync-boards.sh [board ip ...]
#   no boards given: the IPs listed in orphan/boards.local (one per line, git-ignored)
# Projects:
#   Ardzy's 19 examples + 6 starters   from the Ardzy app's folder (Documents/Ardzy, or ARDZY_PROJECTS)
#   orphan_radio, orphan_synth          from this repo (radio-work/, synth-work/)
#   descriptions                        orphan/project-meta/<project>.json -> project.json on the board
# Never touched on the board: each project's runtime data (memories, SSTV pictures, built binaries).
# by JMSCNC, makers of RotatoCAM. GPL-3 + attribution.
set -e
REPO=$(cd "$(dirname "$0")/.." && pwd)
ARDZY=${ARDZY_PROJECTS:-$HOME/Documents/Ardzy}            # the Ardzy app's project folder
BOARDS=${*:-$(cat "$REPO/orphan/boards.local" 2>/dev/null)}
[ -n "$BOARDS" ] || { echo 'usage: bash orphan/sync-boards.sh <board ip> ...  (or list them in orphan/boards.local)'; exit 1; }
EXCL='--exclude=__pycache__ --exclude=memories.json --exclude=sstv --exclude=orphan-rxd --exclude=orphan-fxd --exclude=*.pyc'

for b in $BOARDS; do
	echo "== $b ($(ssh -o ConnectTimeout=5 root@$b hostname))"
	# 1. Orphan menu, branding, services (keeps the board's hostname)
	tar -C "$REPO" -cf - --exclude=__pycache__ orphan | ssh root@$b 'rm -rf /tmp/orphan-src && mkdir -p /tmp/orphan-src && tar -xf - -C /tmp/orphan-src && sh /tmp/orphan-src/orphan/install.sh >/dev/null && echo "   menu + branding installed"'
	# 2. Ardzy's examples and starters
	tar -C "$ARDZY" -cf - . | ssh root@$b 'tar -xf - -C /opt/ardzy/projects && echo "   Ardzy projects: $(ls /opt/ardzy/projects | wc -l) folders"'
	# 3. Orphan's own projects
	RD=$REPO/radio; [ -d "$RD" ] || RD=$REPO/radio-work
	SD=$REPO/synth; [ -d "$SD" ] || SD=$REPO/synth-work
	tar -C "$RD" $EXCL -cf - orphan_radio | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	tar -C "$SD" $EXCL -cf - orphan_synth | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	GD=$REPO/games; [ -d "$GD" ] || GD=$REPO/games-work
	TD=$REPO/toys; [ -d "$TD" ] || TD=$REPO/toys-work
	tar -C "$GD" $EXCL -cf - orphan_nes orphan_gb orphan_sms | ssh root@$b 'tar -xf - -C /opt/ardzy/projects && mkdir -p /opt/orphan-games/roms/nes /opt/orphan-games/roms/gb /opt/orphan-games/roms/sms'
	tar -C "$TD" $EXCL -cf - orphan_toys | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	MD=$REPO/miners; [ -d "$MD" ] || MD=$REPO/miners-work
	tar -C "$MD" $EXCL --exclude=settings.local.json --exclude=devfee.local.json -cf - orphan_btc | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	KD=$REPO/miners; [ -d "$KD/orphan_kas" ] || KD=$REPO/kas-work/repo
	[ -d "$KD/orphan_kas" ] && tar -C "$KD" $EXCL --exclude=settings.local.json --exclude=devfee.local.json -cf - orphan_kas | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	BD=$REPO/lab; [ -d "$BD" ] || BD=$REPO/lab-work
	tar -C "$BD" $EXCL --exclude=names.local.json --exclude=map.local.json --exclude=mitm.local.json --exclude=sim --exclude=build.log -cf - orphan_spektor | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	# MIMIK: the emulated chip's image, settings and slider values stay on the board
	tar -C "$BD" $EXCL --exclude=image.local.bin --exclude=mimik.local.json --exclude=controls.local.json --exclude=sim -cf - orphan_mimik | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	LD=$REPO/lm; [ -d "$LD" ] || LD=$REPO/lm-work
	# TinyLM: the code from here; its model/ (weights) stays on the board (copy it once: see lm/orphan_tinylm/README.md)
	[ -n "${SKIP_LM:-}" ] || tar -C "$LD" $EXCL --exclude=model -cf - orphan_tinylm | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	# your own game libraries (free homebrew), if you keep them: orphan/roms.local = lines "nes <folder>", "gb <folder>", "sms <folder>" (.sms + .gg)
	while read -r sys dir; do
		[ -n "$dir" ] && [ -d "$dir" ] || continue
		pat="*.$sys"; [ "$sys" = sms ] && pat="*.sms *.gg"
		(cd "$dir" && shopt -s nullglob && tar -cf - $pat) | ssh root@$b "tar -xf - -C /opt/orphan-games/roms/$sys && echo \"   $sys games: \$(ls /opt/orphan-games/roms/$sys | wc -l)\""
	done < <(cat "$REPO/orphan/roms.local" 2>/dev/null)
	# Ardzy's web page in the Orphan look (Ardzy inside); the original stays as index.ardzy.html
	ssh root@$b 'W=/opt/ardzy/web; [ -f $W/index.ardzy.html ] || cp $W/index.html $W/index.ardzy.html; python3 - $W/index.ardzy.html $W/index.html' < "$REPO/orphan/brand-ardzy-web.py"
	# Orphan's fan control in Ardzy's example designs (rebuilt by orphan/add-fan.py): replace their bitstreams
	for f in "$REPO"/orphan/fan-bits/*.bit; do [ -f "$f" ] || continue; n=$(basename "$f" .bit)
		ssh root@$b "[ -d /opt/ardzy/projects/$n ] && cat > /opt/ardzy/projects/$n/$n.bit" < "$f"; done
	echo "   fan control bitstreams: $(ls "$REPO"/orphan/fan-bits/*.bit 2>/dev/null | wc -l)"
	# 4. descriptions
	tar -C "$REPO/orphan/project-meta" -cf - . | ssh root@$b 'mkdir -p /tmp/pmeta && tar -xf - -C /tmp/pmeta && for f in /tmp/pmeta/*.json; do p=$(basename $f .json); [ -d /opt/ardzy/projects/$p ] && cp $f /opt/ardzy/projects/$p/project.json; done; rm -rf /tmp/pmeta /tmp/orphan-src
		n=0; for d in /opt/ardzy/projects/*/; do [ -f $d/project.json ] || { echo "   no description: $d"; n=1; }; done
		echo "   $(ls /opt/ardzy/projects | wc -l) projects, all with descriptions: $([ $n = 0 ] && echo yes || echo no)"'
	# descriptions + quick starts (orphan/project-meta/quickstart*.json) merged into each project.json
	tar -C "$REPO/orphan" -cf - merge-quickstart.py project-meta/quickstart.json project-meta/quickstart-orphan.json 2>/dev/null | ssh root@$b 'mkdir -p /tmp/oqs && tar -xf - -C /tmp/oqs && python3 /tmp/oqs/merge-quickstart.py /tmp/oqs/project-meta/quickstart*.json; rm -rf /tmp/oqs'
done
