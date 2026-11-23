#!/bin/sh
# VIZOR's X desktop: a virtual screen (Xvfb, display :1) with the JWM window manager in the Orphan look.
# Xvfb keeps the screen as a file in /dev/shm (-fbdir), which vizor.py reads to send changed tiles to the browser.
# Started on demand by vizor.py (systemctl start vizor-x), so it uses no memory until the X DESKTOP window opens.
# by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
S=/usr/local/share/orphan/vizor
export DISPLAY=:1
export HOME=/var/lib/vizor-x
mkdir -p "$HOME"
# X SETTINGS (VIZOR writes /etc/orphan/vizor-x.env): screen size, DPI, keyboard layout, background colour
[ -f /etc/orphan/vizor-x.env ] && . /etc/orphan/vizor-x.env
# JWM's menu lists every installed program (from the packages' .desktop launchers)
python3 "$S/xapps.py" --jwm >/dev/null 2>&1 || cp "$S/jwmrc" "$HOME/.jwmrc"
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1
Xvfb :1 -screen 0 "${VIZOR_X_SIZE:-1280x720}x16" -fbdir /dev/shm -nolisten tcp -dpi "${VIZOR_X_DPI:-96}" &
XPID=$!
# wait until the server really accepts clients (the socket file appears a moment before that)
i=0
until xsetroot -solid "${VIZOR_X_BG:-#060809}" 2>/dev/null || [ $i -ge 100 ]; do sleep 0.1; i=$((i + 1)); done
[ -n "${VIZOR_X_KBD:-}" ] && setxkbmap "$VIZOR_X_KBD" 2>/dev/null
# the window manager, restarted if it ever exits, for as long as Xvfb runs
( while kill -0 $XPID 2>/dev/null; do jwm >> "$HOME/jwm.log" 2>&1; sleep 1; done ) &
wait $XPID
