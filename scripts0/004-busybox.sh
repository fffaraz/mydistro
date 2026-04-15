#!/bin/bash
set -exuo pipefail

cd ./src/busybox

make defconfig

sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_TC=y/CONFIG_TC=n/' .config

make
make CONFIG_PREFIX=$INITRAMFS_DIR install
