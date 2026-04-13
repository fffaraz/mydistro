#!/bin/bash

# compile syslinux
cd ./src/syslinux

# apply patches
for f in debian/patches/*.patch; do patch -p1 < $f; done; unset f

sed -i '/#include <stdbool.h>/a #include <stdio.h>' ./com32/lib/syslinux/debug.c
sed -i 's/lmalloc\.o/lmalloc.o calloc.o/' ./mk/lib.mk

CFLAGS="" CXXFLAGS="" LDFLAGS="" DATE=not-too-long make OPTFLAGS="-O3 -Wno-error" bios
