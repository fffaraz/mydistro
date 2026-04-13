#!/bin/bash

# compile toybox
cd ./src/toybox

make defconfig
# make menuconfig

make

PREFIX=/opt/mydistro/initramfs-dir make install
