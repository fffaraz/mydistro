#!/bin/bash

# compile toybox
cd ./src/toybox

make defconfig
# make menuconfig

make -j$(nproc)

PREFIX=/opt/mydistro/initramfs-dir make install
