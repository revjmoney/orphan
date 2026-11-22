#!/bin/sh
# Install the Orphan branding into a root filesystem.  Usage: sh install.sh [ROOT] [HOSTNAME]
#   sh install.sh                         this system, keeps the hostname
#   sh install.sh /mnt/flash orphan-flash another root (e.g. the lean flash system mounted from the SD one)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=${1:-}
HOST=${2:-}
S=$ROOT/usr/local/share/orphan
mkdir -p "$S" "$ROOT/usr/local/bin" "$ROOT/etc/profile.d" "$ROOT/etc/orphan"
cp "$HERE/orphan-menu.py" "$HERE/orphan_fan.py" "$HERE/orphan-splash.py" "$HERE/logo_small.txt" "$HERE/logo_big.txt" "$HERE"/logo_*.ans "$S/"
cp "$HERE/quotes.txt" "$S/quotes.txt"
mkdir -p "$ROOT/etc/xdg/fastfetch" && cp "$HERE/fastfetch.jsonc" "$ROOT/etc/xdg/fastfetch/config.jsonc"
cp "$HERE/s9-fan.service" "$ROOT/etc/systemd/system/s9-fan.service"
cp "$HERE/orphan-fclk.service" "$ROOT/etc/systemd/system/orphan-fclk.service"
[ -f "$ROOT/etc/orphan/fan-duty" ] || echo 0 > "$ROOT/etc/orphan/fan-duty"
mkdir -p "$ROOT/etc/systemd/system/multi-user.target.wants"
ln -sf /etc/systemd/system/s9-fan.service "$ROOT/etc/systemd/system/multi-user.target.wants/s9-fan.service"
ln -sf /etc/systemd/system/orphan-fclk.service "$ROOT/etc/systemd/system/multi-user.target.wants/orphan-fclk.service"
# lean flash system: apt's package lists don't fit in the flash, keep them in RAM (re-run `apt update` after boot)
if grep -q "^ubi0:rootfs" "$ROOT/etc/fstab" 2>/dev/null && ! grep -q "/var/lib/apt/lists" "$ROOT/etc/fstab"; then
	printf 'tmpfs\t/var/lib/apt/lists\ttmpfs\tdefaults,size=160m\t0\t0\ntmpfs\t/var/cache/apt\ttmpfs\tdefaults,size=200m\t0\t0\n' >> "$ROOT/etc/fstab"
fi
printf '#!/bin/sh\nexec python3 /usr/local/share/orphan/orphan-menu.py "$@"\n' > "$ROOT/usr/local/bin/orphan"
printf '#!/bin/sh\nexec python3 /usr/local/share/orphan/orphan_fan.py "$@"\n' > "$ROOT/usr/local/bin/orphan-fan"
chmod 755 "$ROOT/usr/local/bin/orphan" "$ROOT/usr/local/bin/orphan-fan" "$S/orphan-menu.py" "$S/orphan-splash.py"
cp "$HERE/orphan.sh" "$ROOT/etc/profile.d/orphan.sh"
[ -f "$ROOT/etc/orphan/login-mode" ] || echo menu > "$ROOT/etc/orphan/login-mode"
cat > "$ROOT/etc/issue" <<'EOF'
\e[38;5;214m\e[1mORPHAN\e[0m  FPGA Dev Linux for the S9 Control Board
\e[96mby JMSCNC, makers of RotatoCAM\e[0m    \n  \l  \4

EOF
printf 'Orphan · FPGA Dev Linux for the S9 Control Board - by JMSCNC, makers of RotatoCAM (jmscnc.com)\n' > "$ROOT/etc/motd"
chmod -x "$ROOT/etc/update-motd.d/10-uname" 2>/dev/null || true     # no Debian "Linux host ..." line
if [ -n "$HOST" ]; then
	echo "$HOST" > "$ROOT/etc/hostname"
	sed -i "s/^127\.0\.1\.1.*/127.0.1.1\t$HOST/" "$ROOT/etc/hosts" 2>/dev/null || true
	grep -q "127.0.1.1" "$ROOT/etc/hosts" || printf '127.0.1.1\t%s\n' "$HOST" >> "$ROOT/etc/hosts"
fi
echo "Orphan installed into ${ROOT:-/}${HOST:+ (hostname $HOST)}"
