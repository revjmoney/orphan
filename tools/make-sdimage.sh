#!/bin/bash
# Build the Orphan SD card image: flash it, set the boot jumpers, power on, and the board is Orphan.
#   sudo bash tools/make-sdimage.sh <orphan tree> <Ardzy-0.3-sdcard.img> [out.img]
#     <orphan tree>   the public Orphan tree (bash tools/export-public.sh, or a clone of github.com/revjmoney/orphan)
#     <Ardzy image>   Ardzy 0.3's SD image (github.com/chrysovalantischryso/ardzy/releases): its open-source
#                     bootloader (U-Boot), kernel and Debian 13 are the base Orphan is built on ("Ardzy inside")
# Needs a Linux PC: losetup, qemu-user-static (binfmt) for the ARM apt step, python3, xz.
# What is in the image: everything Orphan (menu, VIZOR desktop, all [orphan] and [ardzy] FPGA projects with their
# bitstreams, fan control), the X desktop apps (PulseView, GTKWave), mc, fastfetch, git. At its first start the board
# grows the card's partition, makes its own SSH keys and, when online, pulls the newest Orphan from GitHub.
# by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
set -euo pipefail
TREE=$(cd "${1:?usage: make-sdimage.sh <orphan tree> <Ardzy image> [out.img]}" && pwd)
BASE=${2:?Ardzy image}
VER=${ORPHAN_VERSION:-$(date +%Y.%m.%d)}
OUT=${3:-Orphan-$VER-sdcard.img}
PKGS="mc fastfetch git curl htop xvfb jwm python3-xlib pulseview gtkwave xterm fonts-dejavu-core x11-xserver-utils"
banner() { echo; echo "=================== $* ==================="; }
[ "$(id -u)" = 0 ] || { echo "run as root (sudo)"; exit 1; }

banner "1/6  copy the base image"
cp --sparse=always "$BASE" "$OUT"
L=$(losetup -fP --show "$OUT")
M=$(mktemp -d)
cleanup() {
	set +e
	for d in dev/pts dev proc sys boot; do mountpoint -q "$M/$d" && umount -l "$M/$d"; done
	mountpoint -q "$M" && umount "$M"
	losetup -d "$L"
	rmdir "$M"
}
trap cleanup EXIT
mount "${L}p2" "$M"
mkdir -p "$M/boot"
mount "${L}p1" "$M/boot"
echo "base: $(du -sh --exclude=boot "$M" 2>/dev/null | cut -f1) used, card layout:"; sfdisk -l "$OUT" | tail -2

banner "2/6  packages (apt inside the ARM system, through qemu)"
cp /usr/bin/qemu-arm-static "$M/usr/bin/"
mount --bind /dev "$M/dev"; mount --bind /dev/pts "$M/dev/pts"; mount -t proc proc "$M/proc"; mount -t sysfs sys "$M/sys"
cp "$M/etc/resolv.conf" "$M/etc/resolv.conf.orphan-build" 2>/dev/null || true
rm -f "$M/etc/resolv.conf"; cp /etc/resolv.conf "$M/etc/resolv.conf"
printf '#!/bin/sh\nexit 101\n' > "$M/usr/sbin/policy-rc.d"; chmod 755 "$M/usr/sbin/policy-rc.d"   # no services start in the chroot
chroot "$M" apt-get update -qq
chroot "$M" env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends $PKGS
chroot "$M" apt-get clean
rm -rf "$M/var/lib/apt/lists/"*
rm -f "$M/usr/sbin/policy-rc.d" "$M/usr/bin/qemu-arm-static"
rm -f "$M/etc/resolv.conf"; [ -e "$M/etc/resolv.conf.orphan-build" ] && mv "$M/etc/resolv.conf.orphan-build" "$M/etc/resolv.conf"

banner "3/6  Orphan"
# Ardzy's 19 example projects (LED strips, VGA, steppers, RISC-V, AI...) come from Ardzy's own repo; Orphan's
# setup then puts its fan control into them and adds descriptions. ARDZY_EXAMPLES=<folder> uses a local copy.
EX=${ARDZY_EXAMPLES:-}
if [ -z "$EX" ]; then
	EXT=$(mktemp -d)
	git clone -q --depth 1 "${ARDZY_REPO:-https://github.com/chrysovalantischryso/ardzy}" "$EXT/ardzy" && EX=$EXT/ardzy/fpga_projects
fi
if [ -n "$EX" ] && [ -d "$EX" ]; then
	for d in "$EX"/[0-9][0-9]_*; do [ -d "$d" ] && cp -a "$d" "$M/opt/ardzy/projects/"; done
	echo "Ardzy examples: $(ls -d "$M"/opt/ardzy/projects/[0-9][0-9]_* | wc -l)"
fi
mkdir -p "$M/opt/orphan-src"
cp -a "$TREE"/. "$M/opt/orphan-src/"
ROOT="$M" sh "$M/opt/orphan-src/orphan/setup-board.sh" orphan

banner "4/6  first start + identity"
ln -sf /etc/systemd/system/orphan-firstboot.service "$M/etc/systemd/system/multi-user.target.wants/orphan-firstboot.service"
echo "$VER" > "$M/etc/orphan/version"
if [ -d "$TREE/.git" ]; then git -C "$TREE" log -1 --format=%ct > "$M/etc/orphan/build-time"; else date +%s > "$M/etc/orphan/build-time"; fi
cat > "$M/etc/orphan-release" <<EOF
NAME="Orphan"
VERSION="$VER"
PRETTY_NAME="Orphan $VER, FPGA Dev Linux for the S9 Control Board"
HOME_URL="https://github.com/revjmoney/orphan"
VENDOR="JMSCNC, makers of RotatoCAM"
BASED_ON="Ardzy 0.3 by chryso (GPL-3.0), Debian 13"
EOF
# the card's settings file (Ardzy reads it at every boot; edit it on a PC): Orphan's defaults
B="$M/boot/ardzy.txt"
sed -i 's/^timezone.*/timezone  = UTC/' "$B"
sed -i '1s/^.*$/# Orphan board settings (Ardzy inside reads this at every boot). Edit it on a PC: the SD card'"'"'s boot partition./' "$B"
cat > "$M/boot/ORPHAN-README.txt" <<'EOF'
ORPHAN - FPGA Dev Linux for the S9 Control Board
by JMSCNC, makers of RotatoCAM   [Rev. J. Money - 2026]   https://github.com/revjmoney/orphan

1. Put this card in the S9 control board. Set the boot jumpers for SD card boot.
2. Plug in network and power. The first start takes a few minutes (it grows the card, makes SSH keys,
   and pulls the newest Orphan from GitHub when the board is online).
3. Open http://orphan.local:8080 for the VIZOR desktop, http://orphan.local for the board page,
   or ssh root@orphan.local (password: root, change it: passwd).

ardzy.txt on this partition: hostname, password, network, timezone, ssh. Edit it on a PC, then boot.
Built on Ardzy 0.3 by chryso (GPL-3.0) and Debian 13. Orphan is GPL-3.0 with attribution.
EOF

banner "5/6  tidy"
rm -rf "$M/root/.cache" "$M/tmp/"* "$M/var/log/"*.gz 2>/dev/null || true
rm -f "$M/etc/ssh/ssh_host_"*            # every card makes its own keys at its first start
: > "$M/etc/machine-id"
fstrim -v "$M" 2>/dev/null || true
echo "Orphan image: $(du -sh --exclude=boot "$M" | cut -f1) used on the card"
cleanup; trap - EXIT

banner "6/6  compress"
xz -T0 -6 -k -f "$OUT"
sha256sum "$OUT" "$OUT.xz" > "$OUT.sha256"
ls -la "$OUT" "$OUT.xz"
echo "DONE: $OUT.xz  (flash with balenaEtcher or Raspberry Pi Imager)"
