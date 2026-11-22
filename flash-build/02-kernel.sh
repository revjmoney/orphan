#!/bin/bash
# Step 2: the "perfect" S9 kernel: Ardzy's config + writable NAND + UBI/UBIFS + a built-in initramfs that
# picks the root (SD card or flash) + forced cmdline (the stock Bitmain U-Boot hard-codes its own bootargs).
set -euo pipefail
W=~/s9flash; SRC=~/s9build/linux-xlnx; OUT=$W/kout; R=$W/rootfs
export ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
banner() { echo; echo "=================== $* ==================="; }

banner "2/4  initramfs (busybox from the lean rootfs + the root picker)"
I=$W/initramfs; rm -rf "$I"; mkdir -p "$I"/{bin,dev,proc,sys,newroot,sd1}
cp "$R/usr/bin/busybox" "$I/bin/busybox" 2>/dev/null || cp "$R/bin/busybox" "$I/bin/busybox"
file "$I/bin/busybox" | grep -q statically || { echo "busybox is not static"; exit 1; }
cp "$W/init" "$I/init"; chmod 755 "$I/init"
cat > $W/initramfs.list <<EOF
dir /dev 755 0 0
nod /dev/console 600 0 0 c 5 1
nod /dev/null 666 0 0 c 1 3
dir /bin 755 0 0
file /bin/busybox $I/bin/busybox 755 0 0
file /init $I/init 755 0 0
dir /proc 755 0 0
dir /sys 755 0 0
dir /newroot 755 0 0
dir /sd1 755 0 0
dir /tmp 755 0 0
EOF
echo "busybox $(du -h "$I/bin/busybox" | cut -f1)"

banner "2/4  kernel config"
mkdir -p "$OUT"
cp ~/s9build/zynq-antminer-s9.dts "$SRC/arch/arm/boot/dts/xilinx/"
F=$SRC/drivers/mtd/nand/raw/pl35x-nand-controller.c
grep -q 'Ardzy: no on-flash BBT' $F || sed -i 's|\tchip->bbt_options = NAND_BBT_USE_FLASH;|\tchip->bbt_options = 0;\t/* Ardzy: no on-flash BBT, never write to the NAND */|' $F
grep -q 'Ardzy: no on-flash BBT' $F && echo "NAND: in-RAM bad block table (Linux never writes a BBT to the chip)"
cd "$SRC"
make -s O=$OUT xilinx_zynq_defconfig
cp ~/s9build/s9.config $OUT/s9.config
cat >> $OUT/s9.config <<EOF
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_UBIFS_FS_ZSTD=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="$W/initramfs.list"
CONFIG_INITRAMFS_COMPRESSION_GZIP=y
CONFIG_RD_GZIP=y
CONFIG_EXT4_FS=y
CONFIG_VFAT_FS=y
CONFIG_CMDLINE="console=ttyPS0,115200 earlycon panic=10 ubi.mtd=ubi rdinit=/init uio_pdrv_genirq.of_id=generic-uio"
CONFIG_CMDLINE_FORCE=y
CONFIG_LOCALVERSION="-s9flash"
CONFIG_LOCALVERSION_AUTO=n
EOF
scripts/kconfig/merge_config.sh -m -O $OUT $OUT/.config $OUT/s9.config >/dev/null
make -s O=$OUT olddefconfig
for o in MTD_UBI UBIFS_FS UBIFS_FS_ZSTD BLK_DEV_INITRD CMDLINE_FORCE MACB MTD_NAND_PL35X EXT4_FS VFAT_FS; do
	grep -q "^CONFIG_$o=y" $OUT/.config && echo "  $o=y" || { echo "  $o MISSING"; exit 1; }
done
grep "^CONFIG_CMDLINE=" $OUT/.config

banner "2/4  compiling the kernel on 4 cores (~15-20 min)"
time make O=$OUT -j4 zImage modules
make -s O=$OUT INSTALL_MOD_PATH=$W/modules INSTALL_MOD_STRIP=1 modules_install
echo "kernel: $(cat $OUT/include/config/kernel.release)"
