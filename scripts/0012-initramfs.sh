#!/bin/bash
set -x

cp ./assets/init.sh ./initramfs-dir/init
cp ./assets/rcS.sh ./initramfs-dir/etc/init.d/rcS

cp ./src/busybox/examples/inittab ./initramfs-dir/etc/

echo "root::0:0:root:/root:/bin/sh" > ./initramfs-dir/etc/passwd
echo "root:x:0:" > ./initramfs-dir/etc/group
echo "nameserver 8.8.8.8" > ./initramfs-dir/etc/resolv.conf

# large dummy file
# dd if=/dev/zero of=./initramfs-dir/largefile bs=1M count=128

cd ./initramfs-dir

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
find . | cpio -o -H newc > ../output/initramfs.cpio
# -o, --create
# -H, --format=

tar -czvf ../output/initramfs.tar.gz .
