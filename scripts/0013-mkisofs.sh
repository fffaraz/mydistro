#!/bin/bash
set -exuo pipefail

mkdir -p ./iso-dir/isolinux

# kernel
cp ./output/bzImage ./iso-dir/bzImage

# syslinux
cp ./assets/syslinux.cfg ./iso-dir/isolinux/isolinux.cfg
cp ./src/syslinux/bios/core/isolinux.bin ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/lib/libcom32.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/libutil/libutil.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/menu/vesamenu.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/menu/menu.c32 ./iso-dir/isolinux

# memtest86+
cp ./src/memtest86plus/build/x86_64/mt86plus ./iso-dir/memtest

# initramfs
cp ./output/initramfs.cpio ./iso-dir/initramfs.cpio

# mk iso
mkisofs -J -R -o ./output/mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table iso-dir

# alt mk iso
# cd /opt/mydistro/src/linux
# make isoimage FDINITRD=/opt/mydistro/iso-dir/initramfs.cpio FDARGS="initrd=/initramfs.cpio"
# cp /opt/mydistro/src/linux/arch/x86/boot/image.iso ./output/image.iso
