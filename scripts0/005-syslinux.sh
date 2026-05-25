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

# Pass-2 toolchain defaults break syslinux's freestanding com32 loader:
#
# 1. gcc --enable-cet=auto emits endbr32 — disable with -fcf-protection=none.
# 2. binutils 2.31+ defaults to -z separate-code, splitting the .c32 modules
#    into two LOAD segments (R E / RW) with a page-aligned gap. The com32
#    ELF loader expects a single RWE LOAD segment and silently hangs on
#    ldlinux.c32 after isolinux.bin prints its banner.
# 3. as defaults to -mx86-used-note=yes, leaving a .note.gnu.property /
#    GNU_PROPERTY segment behind — strip it from every built .c32.
#
# OPTFLAGS only flows through embedded.mk (isolinux.bin) and lib.mk; elf.mk
# and com32.mk roll their own GCCOPT/LDFLAGS, so patch them directly.
sed -i 's|^GCCOPT += -Os -fomit-frame-pointer$|& -fcf-protection=none|' ./mk/elf.mk
sed -i 's|^GCCOPT += -Os$|& -fcf-protection=none|' ./mk/com32.mk
sed -i 's|^LDFLAGS *= .*elf.ld --as-needed$|& -z noseparate-code|' ./mk/elf.mk
sed -i 's|^LDFLAGS *= .*-T \$(COM32LD)$|& -z noseparate-code|' ./mk/com32.mk

CFLAGS="" CXXFLAGS="" LDFLAGS="" DATE=2020 make OPTFLAGS="-O3 -Wno-error -fcf-protection=none" bios

# Strip asm-emitted GNU property notes from every built .c32 module.
find ./bios -name '*.c32' -exec objcopy --remove-section=.note.gnu.property {} \;
