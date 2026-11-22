#!/bin/sh
# Re-render the Orphan monkey with chafa (style 5: quarter + half blocks, 256 colors).
#   sh render_logos.sh /path/to/monkey.png
for w in 26 32 40 56; do
	chafa -f symbols -c 256 --symbols block+quad+half --size ${w}x200 --bg 000000 "$1" | sed -e 's/\x1b\[?25[lh]//g' > logo_$w.ans
done
