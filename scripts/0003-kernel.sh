#!/bin/bash
set -x

# compile linux kernel

cd /opt/mydistro/src/linux
make defconfig

# make menuconfig

sed -i 's/^CONFIG_CC_VERSION_TEXT=.*/CONFIG_CC_VERSION_TEXT="gcc (mydistro)"/' .config
sed -i 's/# CONFIG_IKCONFIG is not set/CONFIG_IKCONFIG=y/' .config
echo "CONFIG_IKCONFIG_PROC=y" >> .config

make -j$(nproc)

mkdir -p /opt/mydistro/iso-dir
cp ./arch/x86/boot/bzImage /opt/mydistro/iso-dir/bzImage
