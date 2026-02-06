#!/bin/bash
set -exuo pipefail

# create and format boot image
dd if=/dev/zero of=./output/boot.img bs=1M count=512
mkfs -t fat ./output/boot.img
sync

# make boot image
./src/syslinux/bios/mtools/syslinux ./output/boot.img
sync

mkdir -p ./mnt
sync
mount ./output/boot.img ./mnt

# copy kernel and initramfs and memtest86+
cp ./output/bzImage ./mnt
cp ./output/initramfs.cpio ./mnt
cp ./src/memtest86plus/build/x86_64/mt86plus ./mnt

# copy syslinux
cp ./assets/syslinux.cfg ./mnt
cp /usr/lib/syslinux/modules/bios/libcom32.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/libutil.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/vesamenu.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/menu.c32 ./mnt

# unmount image
sync
umount ./mnt
rmdir ./mnt
