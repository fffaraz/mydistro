#!/bin/bash

# compile syslinux

cd /opt/mydistro/src/syslinux
for f in debian/patches/*.patch; do patch -p1 < $f; done; unset f
sed -i '/#include <stdbool.h>/a #include <stdio.h>' ./com32/lib/syslinux/debug.c
DATE=not-too-long make -j$(nproc) bios

mkdir -p /opt/mydistro/iso-dir/isolinux

cp ./bios/core/isolinux.bin /opt/mydistro/iso-dir/isolinux
cp ./bios/com32/elflink/ldlinux/ldlinux.c32 /opt/mydistro/iso-dir/isolinux
cp ./bios/com32/lib/libcom32.c32 /opt/mydistro/iso-dir/isolinux
cp ./bios/com32/libutil/libutil.c32 /opt/mydistro/iso-dir/isolinux
cp ./bios/com32/menu/vesamenu.c32 /opt/mydistro/iso-dir/isolinux
cp ./bios/com32/menu/menu.c32 /opt/mydistro/iso-dir/isolinux
