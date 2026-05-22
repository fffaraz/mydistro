#!/bin/bash
set -exuo pipefail

rm -f ./output/boot.img
dd if=/dev/zero of=./output/boot.img bs=1M count=2048
sync
mkfs -v -t ext4 ./output/boot.img
sync

grub-install --target i386-pc ./output/boot.img
sync

mkdir -p ./mnt
sync
mount ./output/boot.img ./mnt

rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found/*", "/opt/*"} / ./mnt
sync

umount ./mnt
rmdir ./mnt
