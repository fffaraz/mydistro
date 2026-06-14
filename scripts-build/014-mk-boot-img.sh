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

# Install syslinux's boot sector + ldlinux.sys with the mtools/ variant
# ./src/syslinux/bios/linux/syslinux --install ./output/boot.img
./src/syslinux/bios/mtools/syslinux --install ./output/boot.img
sync

# copy payload into the FAT image via mtools (no loop device required)
mcopy -i ./output/boot.img ./output/bzImage ::bzImage
mcopy -i ./output/boot.img ./output/initramfs.cpio.gz ::initramfs.cpio.gz
mcopy -i ./output/boot.img ./src/memtest86plus/build/x86_64/mt86plus ::mt86plus

# copy syslinux config and modules
mcopy -i ./output/boot.img ./assets/syslinux.cfg ::syslinux.cfg
mcopy -i ./output/boot.img ./src/syslinux/bios/com32/lib/libcom32.c32 ::libcom32.c32
mcopy -i ./output/boot.img ./src/syslinux/bios/com32/libutil/libutil.c32 ::libutil.c32
mcopy -i ./output/boot.img ./src/syslinux/bios/com32/menu/vesamenu.c32 ::vesamenu.c32
mcopy -i ./output/boot.img ./src/syslinux/bios/com32/menu/menu.c32 ::menu.c32
sync

exit 0

# Alternative method: mount the image and copy files directly
mkdir -p ./mnt
sync

losetup -f
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
