#!/usr/bin/bash
set -exuo pipefail

# create and format boot image
dd if=/dev/zero of=./output/boot.img bs=1M count=2048
sync

# mkfs -t fat
mkfs.vfat ./output/boot.img
sync

# make boot image
# ./src/syslinux/bios/mtools/syslinux ./output/boot.img

# Use the linux/ variant (direct loop-device install) rather than mtools/ —
# pass 2's rootfs has no mcopy/mformat, which the mtools/ variant shells out to.
./src/syslinux/bios/linux/syslinux --install ./output/boot.img
sync

mkdir -p ./mnt
sync
mount ./output/boot.img ./mnt

# copy kernel and initramfs and memtest86+
cp ./output/bzImage ./mnt
cp ./output/initramfs.cpio.gz ./mnt
cp ./src/memtest86plus/build/x86_64/mt86plus ./mnt

# copy syslinux
cp ./assets/syslinux.cfg ./mnt
cp ./src/syslinux/bios/com32/lib/libcom32.c32 ./mnt
cp ./src/syslinux/bios/com32/libutil/libutil.c32 ./mnt
cp ./src/syslinux/bios/com32/menu/vesamenu.c32 ./mnt
cp ./src/syslinux/bios/com32/menu/menu.c32 ./mnt

# unmount image
sync
umount ./mnt
rmdir ./mnt
