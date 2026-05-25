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

# -fcf-protection=none: pass-2 gcc is built with --enable-cet=auto default,
# so it emits endbr32 + .note.gnu.property into the i386 c32 ELF modules.
# syslinux's freestanding com32 loader can't handle either, which breaks
# vesamenu/libcom32 — both ISO and boot.img fail to boot in pass 2.
#
# OPTFLAGS only reaches embedded.mk (isolinux.bin) and lib.mk; elf.mk and
# com32.mk roll their own GCCOPT and ignore it, so the c32 modules
# (ldlinux/libcom32/libutil/menu/vesamenu) were still being built with CET.
# Result: isolinux.bin's banner printed, then load of ldlinux.c32 hung silently.
# Inject the flag straight into GCCOPT for those two makefiles.
sed -i 's|^GCCOPT += -Os -fomit-frame-pointer$|& -fcf-protection=none|' ./mk/elf.mk
sed -i 's|^GCCOPT += -Os$|& -fcf-protection=none|' ./mk/com32.mk

CFLAGS="" CXXFLAGS="" LDFLAGS="" DATE=not-too-long make OPTFLAGS="-O3 -Wno-error -fcf-protection=none" bios
