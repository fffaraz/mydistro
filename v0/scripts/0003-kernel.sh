#!/bin/bash

cd /opt/mydistro/src/linux
make defconfig

sed -i 's/^CONFIG_CC_VERSION_TEXT=.*/CONFIG_CC_VERSION_TEXT="gcc (mydistro)"/' .config

make -j$(nproc)

cp ./arch/x86/boot/bzImage /opt/mydistro/iso-dir/bzImage
