#!/bin/bash
# Step 3: the flash images.
#   boot.img  = the 32 MB "boot" partition: stock Bitmain BOOT.bin (FSBL + U-Boot, from YOUR board's NAND backup mtd0.bin)
#               + our DTB at 0x1020000 + our uImage at 0x1100000 (offsets the stock U-Boot reads)
#   ubi.img   = the "ubi" partition: one UBIFS volume "rootfs" (lean Debian), zstd compressed
set -euo pipefail
W=~/s9flash; SRC=~/s9build/linux-xlnx; OUT=$W/kout; R=$W/rootfs
banner() { echo; echo "=================== $* ==================="; }

banner "3/4  device tree: 2 writable NAND partitions + a fixed MAC"
# Each board needs its OWN MAC (the same image on two boards would clash on the network).
# ORPHAN_MAC="7a xx xx xx xx xx" (hex bytes, first byte 7a = locally administered), else flash-build/mac.local,
# else a new random one (printed below: keep it, or the board gets a new address from DHCP after a rebuild).
MAC=${ORPHAN_MAC:-$(cat "$(dirname "$0")/mac.local" 2>/dev/null || printf '7a %02x %02x %02x %02x %02x' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)))}
echo "MAC address: $MAC"
export MAC
D=$SRC/arch/arm/boot/dts/xilinx/zynq-antminer-s9-flash.dts
perl -0pe '
  s/\t\tethernet0 = &gem0;\n//;
  s/(\tphy-mode = "rgmii-id";\n)/$1\tlocal-mac-address = [$ENV{MAC}];\n/;
  s/(\tnand\@0 \{\n)/$1\t\tnand-ecc-mode = "on-die";\n/;   # MUST match the Zynq BootROM + Bitmain U-Boot (Micron on-die 4-bit ECC)
  s/partition\@0 \{.*?\n\t\t\t\};/partition\@0 {\n\t\t\t\tlabel = "boot";\n\t\t\t\treg = <0x0 0x2000000>;\n\t\t\t};\n\t\t\tpartition\@2000000 {\n\t\t\t\tlabel = "ubi";\n\t\t\t\treg = <0x2000000 0xdf80000>;\n\t\t\t};/s;
' ~/s9build/zynq-antminer-s9.dts > "$D"
grep -nE 'label = "(boot|ubi)"|local-mac|ethernet0|read-only' "$D" || true
dtc -@ -I dts -O dtb -o $W/s9flash.dtb <(cpp -nostdinc -undef -x assembler-with-cpp -D__DTS__ -I $SRC/include -I $SRC/arch/arm/boot/dts -I $SRC/arch/arm/boot/dts/xilinx "$D") 2>/dev/null
echo "dtb $(stat -c %s $W/s9flash.dtb) bytes"

banner "3/4  uImage (the stock U-Boot reads at most 8 MB)"
mkimage -A arm -O linux -T kernel -C none -a 0x8000 -e 0x8000 -n "Linux-s9flash" -d $OUT/arch/arm/boot/zImage $W/uImage >/dev/null
S=$(stat -c %s $W/uImage); echo "uImage $S bytes"
[ $S -lt $((0x7F0000)) ] || { echo "uImage too big for the 8 MB U-Boot read"; exit 1; }

banner "3/4  boot partition image (32 MB)"
python3 - "$W" <<'EOF'
import sys
w = sys.argv[1]
stock = open(w + '/mtd0.bin', 'rb').read()
img = bytearray(b'\xff' * 0x2000000)
img[:0x280000] = stock[:0x280000]                    # BOOT.bin: FSBL + bitstream + U-Boot 2014.01
dtb = open(w + '/s9flash.dtb', 'rb').read(); img[0x1020000:0x1020000 + len(dtb)] = dtb
k = open(w + '/uImage', 'rb').read();        img[0x1100000:0x1100000 + len(k)] = k
open(w + '/boot.img', 'wb').write(img)
print('boot.img: BOOT.bin %d KB, dtb at 0x1020000, uImage at 0x1100000' % (0x280000 // 1024))
EOF

banner "3/4  modules into the lean rootfs, then UBIFS + UBI images"
KR=$(cat $OUT/include/config/kernel.release)
sudo rm -rf "$R/lib/modules/$KR"; sudo mkdir -p "$R/lib/modules"; sudo cp -a "$W/modules/lib/modules/$KR" "$R/lib/modules/"
# 2048 B pages, 128 KiB blocks, no sub-pages -> LEB 126976; ubi partition 1788 PEBs, ~1740 usable LEBs
sudo mkfs.ubifs -r "$R" -m 2048 -e 126976 -c 1740 -x zstd -F -o $W/rootfs.ubifs
cat > $W/ubinize.cfg <<EOF
[rootfs]
mode=ubi
image=$W/rootfs.ubifs
vol_id=0
vol_type=dynamic
vol_name=rootfs
vol_flags=autoresize
EOF
ubinize -o $W/ubi.img -m 2048 -p 128KiB -s 2048 $W/ubinize.cfg
ls -l $W/boot.img $W/ubi.img $W/rootfs.ubifs
md5sum $W/boot.img $W/ubi.img
