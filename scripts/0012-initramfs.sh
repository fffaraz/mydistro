#!/bin/bash
set -x

cp ./assets/init.sh ./initramfs-dir/init
cp ./src/busybox/examples/inittab ./initramfs-dir/etc/
cp ./assets/rcS.sh ./initramfs-dir/etc/init.d/rcS
touch ./initramfs-dir/etc/fstab

echo "root::0:0:root:/root:/bin/sh" > ./initramfs-dir/etc/passwd
echo "root:x:0:" > ./initramfs-dir/etc/group
echo "nameserver 8.8.8.8" > ./initramfs-dir/etc/resolv.conf

# large dummy file
# dd if=/dev/zero of=./initramfs-dir/largefile bs=1M count=128

# -o, --create
# -H, --format=
find ./initramfs-dir | cpio -o -H newc > ./output/initramfs.cpio
