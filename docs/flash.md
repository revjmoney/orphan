# Orphan in the board's NAND flash (advanced)

The SD card is the simple way. A board can also boot Orphan's own kernel from its 256 MB NAND flash, and pick
its system at every boot:

- **SD card in**: the full Orphan system on the card
- **no card** (or a file named `flash-root` on the card's FAT partition): a lean Debian kept in the flash
  (SSH, Python, git, the Orphan menu, Ardzy's web app and FPGA loading; about 46 MB free)

Jumpers: **JP2 only** for this mode; JP2 + JP4 still boots the SD card directly (the rescue path).

## Build

`flash-build/` holds the scripts, run on a Linux PC as a user with sudo:

| Script | Makes |
|---|---|
| `01-rootfs.sh` | the lean Debian 13 root (debootstrap, armhf) with Orphan installed |
| `02-kernel.sh` | the kernel with an initramfs (`init`) that chooses SD or flash |
| `03-images.sh` | `boot.img` (the boot partition) and `ubi.img` (the lean system) |
| `build-all.sh` | all three |

Inputs the scripts expect (paths at the top of each script):

- `~/s9flash/mtd0.bin`: a backup of **your own board's** NAND boot partition (`nanddump /dev/mtd0`)
- `~/s9build/linux-xlnx`: Xilinx's Linux tree (tag `xilinx-v2026.1`), configured with Ardzy's S9 config
- `ARDZY_ROOT`: a mounted Ardzy root filesystem (partition 2 of Ardzy's SD image), for Ardzy's tools
- an `arm-linux-gnueabihf-` cross compiler, debootstrap, qemu-user-static, mtd-utils

The boot partition keeps **the boot loader that is already in your board's flash** (the first 2.5 MB of
`mtd0.bin`). Orphan does not ship one.

## The NAND ECC gotcha

The S9's NAND must be written with the Micron chip's **on-die ECC** (device tree `nand-ecc-mode = "on-die"`).
The default Zynq controller ECC writes a boot image the board will not boot (the FPGA "done" LED stays off).
`03-images.sh` sets it; check it before writing anything.

## Before you write the NAND

- Back up the whole NAND first (`nanddump` of every partition) and keep the files off the board.
- Have a way back: a 3.3 V USB-serial adapter on **J12** (115200 baud), or an SD card that boots with JP2 + JP4.
- Write with `flash_erase` + `nandwrite -p`, and read back and compare checksums before rebooting.
