#!/bin/bash
set -exuo pipefail

# compile linux kernel
cd ./src/linux

make defconfig

# https://www.kernelconfig.io/
# make menuconfig

./scripts/config --enable IKCONFIG
./scripts/config --enable IKCONFIG_PROC
./scripts/config --enable DRM_FBDEV_EMULATION # Enable legacy fbdev support for your modesetting driver
./scripts/config --enable DRM_BOCHS           # DRM Support for bochs dispi vga interface (qemu stdvga)
./scripts/config --enable LOGO                # Bootup logo
./scripts/config --enable KERNEL_ZSTD
./scripts/config --enable LD_DEAD_CODE_DATA_ELIMINATION

./scripts/config --disable DEBUG_INFO
./scripts/config --enable DEBUG_INFO_NONE

make olddefconfig

make

cp ./arch/x86/boot/bzImage ../../output/bzImage

make headers_install INSTALL_HDR_PATH=$INITRAMFS_DIR/usr
