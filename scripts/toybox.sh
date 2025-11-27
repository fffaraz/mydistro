#!/bin/bash

# compile toybox

cd /opt/mydistro/src/toybox
make defconfig

# make menuconfig

make -j$(nproc)

mkdir -p /opt/mydistro/initramfs-dir
PREFIX=/opt/mydistro/initramfs-dir make install
