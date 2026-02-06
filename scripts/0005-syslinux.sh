#!/bin/bash

# compile syslinux
cd ./src/syslinux

# apply patches
for f in debian/patches/*.patch; do patch -p1 < $f; done; unset f
sed -i '/#include <stdbool.h>/a #include <stdio.h>' ./com32/lib/syslinux/debug.c

DATE=not-too-long make -j$(nproc) bios
