#!/bin/bash
set -exuo pipefail

cp ./assets/init.sh ./initramfs-dir/init
cp ./assets/rcS.sh ./initramfs-dir/etc/init.d/rcS
chmod +x ./initramfs-dir/init ./initramfs-dir/etc/init.d/rcS

cp ./src/busybox/examples/inittab ./initramfs-dir/etc/
cp ./assets/hosts ./initramfs-dir/etc/hosts
cp ./assets/resolv.conf ./initramfs-dir/etc/resolv.conf

touch ./initramfs-dir/etc/fstab
echo "root::0:0:root:/root:/bin/sh" >./initramfs-dir/etc/passwd
echo "root:x:0:" >./initramfs-dir/etc/group

ln -sv /proc/self/mounts ./initramfs-dir/etc/mtab

# large dummy file
# dd if=/dev/zero of=./initramfs-dir/largefile bs=1M count=128

cd ./initramfs-dir

# remove unnecessary files
rm -rf ./tmp/*

# fix symlink targets
rm ./sbin
rm ./usr/bin
rm ./usr/sbin
rm ./usr/local/bin
rm ./usr/local/sbin
rm ./usr/lib
rm ./usr/local/lib
ln -s /bin ./sbin
ln -s /bin ./usr/bin
ln -s /bin ./usr/sbin
ln -s /bin ./usr/local/bin
ln -s /bin ./usr/local/sbin
ln -s /lib ./usr/lib
ln -s /lib ./usr/local/lib

# create initramfs.cpio
find . | cpio -o -H newc >../output/initramfs.cpio
# -o, --create
# -H, --format=

tar -czvf ../output/initramfs.tar.gz .
