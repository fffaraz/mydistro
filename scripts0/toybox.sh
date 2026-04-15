#!/bin/bash
set -exuo pipefail

# compile toybox
cd ./src/toybox

make defconfig || true
# make menuconfig

sed -i 's/# CONFIG_INIT is not set/CONFIG_INIT=y/' .config
sed -i 's/# CONFIG_GETTY is not set/CONFIG_GETTY=y/' .config
sed -i 's/# CONFIG_VI is not set/CONFIG_VI=y/' .config
make oldconfig

make
make install DESTDIR=$INITRAMFS_DIR
