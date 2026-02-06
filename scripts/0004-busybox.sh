#!/bin/bash

# compile busybox

cd ./src/busybox
make defconfig

sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_TC=y/CONFIG_TC=n/' .config

make -j$(nproc)

make CONFIG_PREFIX=/opt/mydistro/initramfs-dir install
