#!/bin/bash
set -exuo pipefail

rm -f ./output/boot.img
dd if=/dev/zero of=./output/boot.img bs=1M count=2048
sync

# Partition table so GRUB has a place for boot.img + core.img
parted -s ./output/boot.img mklabel msdos
parted -s ./output/boot.img mkpart primary ext4 1MiB 100%
parted -s ./output/boot.img set 1 boot on
sync

# Loop-mount so grub-probe sees a real block device, not 'overlay'
LOOPDEV=$(losetup -f --show -P ./output/boot.img)
trap 'umount ./mnt 2>/dev/null || true; losetup -d "$LOOPDEV" 2>/dev/null || true' EXIT

mkfs.ext4 -F "${LOOPDEV}p1"
sync

mkdir -p ./mnt
mount "${LOOPDEV}p1" ./mnt
mkdir -p ./mnt/boot

grub-install \
    --target=i386-pc \
    --boot-directory=./mnt/boot \
    --modules="part_msdos ext2" \
    "$LOOPDEV"
sync

rsync -aAXv \
    --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found/*","/opt/*"} \
    / ./mnt
sync

umount ./mnt
losetup -d "$LOOPDEV"
trap - EXIT
rmdir ./mnt
