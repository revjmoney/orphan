#!/bin/bash
# S9 "flash base + SD upgrade" build, run on a Linux PC (see docs/flash.md).
set -euo pipefail
cd ~/s9flash
START=$(date +%s)
echo "S9 flash build started $(date)"
bash 01-rootfs.sh
bash 02-kernel.sh
bash 03-images.sh
echo
echo "=================== 4/4  DONE in $(( ($(date +%s) - START) / 60 )) min ==================="
echo "images in ~/s9flash: boot.img (boot partition), ubi.img (lean Debian), modules/ (for the SD card)"
