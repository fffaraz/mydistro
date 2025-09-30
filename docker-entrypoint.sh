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

cp ./assets/init.sh ./initramfs-dir/init
cp ./assets/syslinux.cfg ./iso-dir/isolinux/isolinux.cfg

./scripts/0012-initramfs.sh

cp ./src/linux/arch/x86/boot/bzImage ./output/bzImage
cp ./iso-dir/initramfs.cpio ./output/initramfs.cpio
cp ./mydistro.iso ./output/mydistro.iso

./assets/mk-boot-img.sh
cp ./boot.img ./output/boot.img
