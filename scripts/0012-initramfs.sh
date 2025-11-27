#!/bin/bash
set -x

cp ./assets/init.sh ./initramfs-dir/init
cp ./assets/syslinux.cfg ./iso-dir/isolinux/isolinux.cfg

cd /opt/mydistro/initramfs-dir

# dd if=/dev/zero of=./largefile bs=1M count=128

mkdir -p etc/init.d proc sys tmp home mnt usr/lib var

cp /opt/mydistro/src/busybox/examples/inittab ./etc/
cp ../assets/rcS.sh ./etc/init.d/rcS
touch ./etc/fstab

echo "root::0:0:root:/root:/bin/sh" > ./etc/passwd
echo "root:x:0:" > ./etc/group
echo "nameserver 8.8.8.8" > ./etc/resolv.conf

# -o, --create
# -H, --format=
find . | cpio -o -H newc > /opt/mydistro/iso-dir/initramfs.cpio

cd /opt/mydistro
mkdir -p ./output
mkisofs -J -R -o ./output/mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table iso-dir

# alt mk iso
# cd /opt/mydistro/src/linux
# make isoimage FDINITRD=/opt/mydistro/iso-dir/initramfs.cpio FDARGS="initrd=/initramfs.cpio"
# cp /opt/mydistro/src/linux/arch/x86/boot/image.iso ./output/image.iso
