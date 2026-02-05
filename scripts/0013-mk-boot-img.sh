#!/bin/bash
set -exuo pipefail

cd /opt/mydistro
mkdir -p ./output

dd if=/dev/zero of=./output/boot.img bs=1M count=512
mkfs -t fat ./output/boot.img
sync

/opt/mydistro/src/syslinux/bios/mtools/syslinux ./output/boot.img
sync

mkdir -p ./mnt
sync

mount ./output/boot.img ./mnt

cp ./iso-dir/bzImage ./mnt
cp ./iso-dir/initramfs.cpio ./mnt
cp ./iso-dir/memtest ./mnt
cp ./iso-dir/isolinux/isolinux.cfg ./mnt/syslinux.cfg

cp /usr/lib/syslinux/modules/bios/libcom32.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/libutil.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/vesamenu.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/menu.c32 ./mnt

sync
umount ./mnt
rmdir ./mnt
