#!/bin/bash
set -exuo pipefail

cd /opt/mydistro
cp -r ./src-ro ./src

./scripts/0001-kernel.sh
./scripts/0002-initramfs.sh
./scripts/0004-busybox.sh
./scripts/0005-syslinux.sh
./scripts/0006-memtest86.sh
./scripts/0007-microwindows.sh
./scripts/0008-dropbear.sh
./scripts/0010-curl.sh
./scripts/0011-nano.sh
./scripts/0012-initramfs.sh
./scripts/0013-mkisofs.sh
./scripts/0014-mk-boot-img.sh
