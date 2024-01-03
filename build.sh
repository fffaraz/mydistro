#!/bin/bash

dd if=/dev/zero of=boot.img bs=1M count=50
mkfs -t fat boot.img

syslinux boot.img

mkdir mnt
mount boot.img mnt

cp ./myiso/bzImage mnt
cp ./myiso/initramfs mnt
cp ./myiso/memtest mnt
cp ./myiso/isolinux/isolinux.cfg mnt/syslinux.cfg

umount mnt
rmdir mnt
