#!/bin/bash
set -exuo pipefail

./scripts/0002-source.sh
./scripts/0003-kernel.sh
./scripts/0004-busybox.sh
./scripts/0005-syslinux.sh
./scripts/0006-memtest86.sh
./scripts/0007-microwindows.sh
./scripts/0008-dropbear.sh
./scripts/0010-curl.sh
./scripts/0011-nano.sh

cp ./assets/init.sh /opt/mydistro/initramfs-dir/init
cp ./assets/syslinux.cfg /opt/mydistro/iso-dir/isolinux/isolinux.cfg

./scripts/0012-initramfs.sh

./assets/mk-boot-img.sh
