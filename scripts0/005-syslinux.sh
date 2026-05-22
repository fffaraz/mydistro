#!/bin/bash
set -exuo pipefail

cd ./src/syslinux

# apply patches
for f in debian/patches/*.patch; do patch -p1 <$f; done
unset f

sed -i '/#include <stdbool.h>/a #include <stdio.h>' ./com32/lib/syslinux/debug.c
sed -i 's/lmalloc\.o/lmalloc.o calloc.o/' ./mk/lib.mk

# cmenu's demo menus (test.c32, test2.c32) are generated from *.menu via menugen.py,
# which needs a `python` interpreter. Pass 2 has no python, and these demo .c32s
# are not installed anyway — drop the .menu files so menugen.py is never invoked.
rm -f ./com32/cmenu/*.menu

CFLAGS="" CXXFLAGS="" LDFLAGS="" DATE=not-too-long make OPTFLAGS="-O3 -Wno-error" bios
