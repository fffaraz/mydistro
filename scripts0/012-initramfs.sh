#!/bin/bash
set -exuo pipefail

cp ./assets/etc/init.d/rcS ./initramfs-dir/etc/init.d/rcS
cp ./assets/etc/hostname ./initramfs-dir/etc/hostname
cp ./assets/etc/hosts ./initramfs-dir/etc/hosts
cp ./assets/etc/os-release ./initramfs-dir/etc/os-release
cp ./assets/etc/profile ./initramfs-dir/etc/profile
cp ./assets/etc/resolv.conf ./initramfs-dir/etc/resolv.conf
cp ./src/busybox/examples/inittab ./initramfs-dir/etc/inittab

chmod +x ./initramfs-dir/etc/init.d/rcS

touch ./initramfs-dir/etc/fstab
echo "root::0:0:root:/root:/bin/sh" >./initramfs-dir/etc/passwd
echo "root:x:0:" >./initramfs-dir/etc/group

ln -sv /sbin/init ./initramfs-dir/init
ln -sv /proc/self/mounts ./initramfs-dir/etc/mtab

mkdir -p ./initramfs-dir/etc/ssl/certs
cp ./src/cacert/cacert-*.pem ./initramfs-dir/etc/ssl/certs/ca-certificates.crt

# large dummy file
# dd if=/dev/zero of=./initramfs-dir/largefile bs=1M count=128

cd ./initramfs-dir

# remove unnecessary files
rm -rf ./tmp/*

# strip all binaries
find ./usr/bin -type f -exec strip --strip-all {} + 2>/dev/null || true

# create initramfs.cpio
find . | cpio -o -H newc >../output/initramfs.cpio
# -o, --create
# -H, --format=

# gzip cpio archive
gzip -f ../output/initramfs.cpio

# create initramfs.tar.gz
tar -czvf ../output/initramfs.tar.gz .
