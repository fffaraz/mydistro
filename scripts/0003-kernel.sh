#!/bin/bash

# compile linux kernel

cd /opt/mydistro/src/linux
make defconfig

# make menuconfig

sed -i 's/^CONFIG_CC_VERSION_TEXT=.*/CONFIG_CC_VERSION_TEXT="gcc (mydistro)"/' .config

make -j$(nproc)

mkdir -p /opt/mydistro/iso-dir
cp ./arch/x86/boot/bzImage /opt/mydistro/iso-dir/bzImage
