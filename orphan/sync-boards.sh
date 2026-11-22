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
	tar -C "$GD" $EXCL -cf - orphan_nes orphan_gb | ssh root@$b 'tar -xf - -C /opt/ardzy/projects && mkdir -p /opt/orphan-games/roms/nes /opt/orphan-games/roms/gb'
	tar -C "$TD" $EXCL -cf - orphan_toys | ssh root@$b 'tar -xf - -C /opt/ardzy/projects'
	# your own game libraries (free homebrew), if you keep them: orphan/roms.local = lines "nes <folder>", "gb <folder>"
	while read -r sys dir; do
		[ -n "$dir" ] && [ -d "$dir" ] || continue
		(cd "$dir" && tar -cf - *.$sys) | ssh root@$b "tar -xf - -C /opt/orphan-games/roms/$sys && echo \"   $sys games: \$(ls /opt/orphan-games/roms/$sys | wc -l)\""
	done < <(cat "$REPO/orphan/roms.local" 2>/dev/null)
	# 4. descriptions
	tar -C "$REPO/orphan/project-meta" -cf - . | ssh root@$b 'mkdir -p /tmp/pmeta && tar -xf - -C /tmp/pmeta && for f in /tmp/pmeta/*.json; do p=$(basename $f .json); [ -d /opt/ardzy/projects/$p ] && cp $f /opt/ardzy/projects/$p/project.json; done; rm -rf /tmp/pmeta /tmp/orphan-src
		n=0; for d in /opt/ardzy/projects/*/; do [ -f $d/project.json ] || { echo "   no description: $d"; n=1; }; done
		echo "   $(ls /opt/ardzy/projects | wc -l) projects, all with descriptions: $([ $n = 0 ] && echo yes || echo no)"'
done
