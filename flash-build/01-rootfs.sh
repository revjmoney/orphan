#!/bin/bash
# Step 1: lean Debian 13 (armhf) for the S9's NAND, built on a Linux PC with qemu-user-static.
set -euo pipefail
W=${W:-$HOME/s9flash}; R=$W/rootfs; ARDZY=${ARDZY_ROOT:-/srv/s9/rootfs}   # ARDZY_ROOT: a mounted Ardzy root (its SD image, partition 2)
banner() { echo; echo "=================== $* ==================="; }

banner "1/4  host tools"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq debootstrap qemu-user-static binfmt-support mtd-utils >/dev/null
[ -e /usr/share/debootstrap/scripts/trixie ] || sudo ln -s sid /usr/share/debootstrap/scripts/trixie
echo "ok: debootstrap $(dpkg-query -W -f='${Version}' debootstrap), qemu-arm-static, mkfs.ubifs"

banner "1/4  debootstrap Debian 13 trixie armhf (this is the slow part)"
PKGS=systemd-sysv,udev,dbus,openssh-server,iproute2,iputils-ping,avahi-daemon,libnss-mdns,ca-certificates,curl,wget,nano,less,htop,fastfetch,mc,screen,minicom,git,i2c-tools,mtd-utils,device-tree-compiler,kmod,procps,python3,python3-numpy,python3-serial,busybox-static,systemd-timesyncd,fake-hwclock,sudo
sudo rm -rf "$R"; sudo mkdir -p "$R/etc/dpkg/dpkg.cfg.d"
# keep docs, man pages and translations out of the flash
sudo tee "$R/etc/dpkg/dpkg.cfg.d/01-lean" >/dev/null <<'EOF'
path-exclude=/usr/share/doc/*
path-include=/usr/share/doc/*/copyright
path-exclude=/usr/share/man/*
path-exclude=/usr/share/info/*
path-exclude=/usr/share/locale/*
path-include=/usr/share/locale/locale.alias
path-exclude=/usr/share/lintian/*
EOF
sudo debootstrap --arch=armhf --variant=minbase --include="$PKGS" trixie "$R" http://deb.debian.org/debian

banner "1/4  configure: hostname, network, ssh key, Ardzy tools"
echo ardzy-flash | sudo tee "$R/etc/hostname" >/dev/null
printf '127.0.0.1\tlocalhost\n127.0.1.1\tardzy-flash\n' | sudo tee "$R/etc/hosts" >/dev/null
printf 'ubi0:rootfs\t/\tubifs\tdefaults,noatime\t0\t0\ntmpfs\t/tmp\ttmpfs\tdefaults,nosuid,nodev\t0\t0\n' | sudo tee "$R/etc/fstab" >/dev/null
sudo mkdir -p "$R/etc/systemd/network"
printf '[Match]\nName=eth* en* end*\n\n[Network]\nDHCP=yes\nMulticastDNS=no\n' | sudo tee "$R/etc/systemd/network/10-eth.network" >/dev/null
sudo chroot "$R" systemctl enable systemd-networkd ssh avahi-daemon >/dev/null 2>&1 || true
sudo mkdir -p "$R/root/.ssh"; sudo cp "$W/authorized_keys" "$R/root/.ssh/authorized_keys"
sudo chmod 700 "$R/root/.ssh"; sudo chmod 600 "$R/root/.ssh/authorized_keys"
sudo chroot "$R" passwd -l root >/dev/null     # SSH keys only until you set a password
# Ardzy: CLI, Python library, web panel, FPGA designs, board/autoload/web/app services, small starter projects
for p in usr/lib/ardzy opt/ardzy/web usr/local/bin/ardzy usr/local/sbin/ardzy-board-init usr/lib/python3/dist-packages/ardzy.py usr/lib/python3/dist-packages/ardzy_board.py usr/lib/python3/dist-packages/ardzy_env.py; do
	sudo mkdir -p "$R/$(dirname $p)"; sudo cp -a "$ARDZY/$p" "$R/$p"
done
sudo mkdir -p "$R/opt/ardzy/projects" "$R/var/lib/ardzy"
for p in blink board_hello leds_python ardzy_io; do sudo cp -a "$ARDZY/opt/ardzy/projects/$p" "$R/opt/ardzy/projects/"; done
for u in ardzy-web ardzy-board ardzy-autoload ardzy-app; do sudo cp -a "$ARDZY/etc/systemd/system/$u.service" "$R/etc/systemd/system/"; done
sudo chroot "$R" systemctl enable ardzy-web ardzy-board ardzy-autoload >/dev/null 2>&1 || true
# Orphan branding: splash, lightbar menu, `orphan` command, login hook (copy the repo's orphan/ dir to ~/s9flash/orphan)
[ -d "$W/orphan" ] && sudo sh "$W/orphan/install.sh" "$R" orphan-flash
sudo chroot "$R" apt-get clean
sudo rm -rf "$R/var/lib/apt/lists/"* "$R/var/cache/apt/"*.bin
echo "lean rootfs: $(sudo du -sh "$R" | cut -f1) uncompressed"
