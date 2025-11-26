#!/bin/bash

cd /opt/mydistro/initramfs-dir

# dd if=/dev/zero of=./largefile bs=1M count=128

mkdir -p etc/init.d proc sys tmp home mnt usr/lib var

cp /opt/mydistro/src/busybox/examples/inittab ./etc/

touch ./etc/init.d/rcS
chmod +x ./etc/init.d/rcS

touch ./etc/fstab

echo "root::0:0:root:/root:/bin/sh" > ./etc/passwd
echo "root:x:0:" > ./etc/group
echo "nameserver 8.8.8.8" > ./etc/resolv.conf

# -o, --create
# -H, --format=
find . | cpio -o -H newc > /opt/mydistro/iso-dir/initramfs.cpio

cd /opt/mydistro
mkisofs -J -R -o mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table iso-dir
