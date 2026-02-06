#!/bin/bash
set -x

# compile linux kernel

cd ./src/linux

make defconfig

# https://www.kernelconfig.io/
# make menuconfig

./scripts/config --enable IKCONFIG
./scripts/config --enable IKCONFIG_PROC
./scripts/config --enable DRM_FBDEV_EMULATION # Enable legacy fbdev support for your modesetting driver
./scripts/config --enable DRM_BOCHS # DRM Support for bochs dispi vga interface (qemu stdvga)
./scripts/config --enable LOGO # Bootup logo

make olddefconfig

make -j$(nproc)

cp ./arch/x86/boot/bzImage /opt/mydistro/output/bzImage
