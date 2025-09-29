#!/bin/bash

cd /opt/mydistro

dd if=/dev/zero of=boot.img bs=1M count=512
mkfs -t fat boot.img
sync

syslinux boot.img
sync

mkdir -p ./mnt
sync

mount boot.img ./mnt

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

# cp boot.img /output
# cp mydistro.iso /output
