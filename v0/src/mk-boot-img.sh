#!/bin/bash

cd /opt/mydistro

dd if=/dev/zero of=boot.img bs=1M count=50
mkfs -t fat boot.img

syslinux boot.img

mkdir mnt
mount boot.img mnt

cp ./myiso/bzImage ./mnt
cp ./myiso/initramfs ./mnt
cp ./myiso/memtest ./mnt
cp ./myiso/isolinux/isolinux.cfg ./mnt/syslinux.cfg
cp /usr/lib/syslinux/modules/bios/libcom32.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/libutil.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/vesamenu.c32 ./mnt
cp /usr/lib/syslinux/modules/bios/menu.c32 ./mnt

umount mnt
rmdir mnt

# cp boot.img /output
# cp mydistro.iso /output
