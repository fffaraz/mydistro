#!/bin/bash
set -x

# compile linux kernel

cd /opt/mydistro/src/linux
make defconfig

# make menuconfig

sed -i 's/^CONFIG_CC_VERSION_TEXT=.*/CONFIG_CC_VERSION_TEXT="gcc (mydistro)"/' .config

# ./scripts/config --enable IKCONFIG
# ./scripts/config --enable IKCONFIG_PROC
sed -i 's/# CONFIG_IKCONFIG is not set/CONFIG_IKCONFIG=y/' .config
echo "CONFIG_IKCONFIG_PROC=y" >> .config

# CONFIG_DRM_FBDEV_EMULATION: Enable legacy fbdev support for your modesetting driver
# CONFIG_DRM_BOCHS: DRM Support for bochs dispi vga interface (qemu stdvga)
# CONFIG_LOGO: Bootup logo

cp /opt/mydistro/assets/linux.config .config

# make olddefconfig

make -j$(nproc)

mkdir -p /opt/mydistro/iso-dir
cp ./arch/x86/boot/bzImage /opt/mydistro/iso-dir/bzImage
