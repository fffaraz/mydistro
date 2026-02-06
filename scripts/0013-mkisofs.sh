#!/bin/bash
set -exuo pipefail

mkdir -p ./iso-dir/isolinux

# copy kernel and initramfs and memtest86+
cp ./output/bzImage ./iso-dir
cp ./output/initramfs.cpio ./iso-dir
cp ./src/memtest86plus/build/x86_64/mt86plus ./iso-dir/memtest

# copy syslinux
cp ./assets/syslinux.cfg ./iso-dir/isolinux/isolinux.cfg
cp ./src/syslinux/bios/core/isolinux.bin ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/lib/libcom32.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/libutil/libutil.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/menu/vesamenu.c32 ./iso-dir/isolinux
cp ./src/syslinux/bios/com32/menu/menu.c32 ./iso-dir/isolinux

# mk iso
mkisofs -J -R -o ./output/mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table iso-dir

# alt mk iso
# cd ./src/linux
# make isoimage FDINITRD=/opt/mydistro/output/initramfs.cpio FDARGS="initrd=/initramfs.cpio"
# cp ./arch/x86/boot/image.iso /opt/mydistro/output/image.iso
