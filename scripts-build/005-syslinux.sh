#!/bin/bash
set -exuo pipefail

# https://src.fedoraproject.org/rpms/syslinux
# git://git.kernel.org/pub/scm/boot/syslinux/syslinux.git

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

# DIAGNOSTIC BUILD — pass-2 still hangs after the ISOLINUX banner with no
# error message. Enable every syslinux trace knob so we can see exactly which
# step of pm_fs_init / load_env32 dies:
#   - tracers.inc: uncomment DEBUG_MESSAGES + DEBUG_TRACERS (nasm side, real-mode
#     status lines + per-step single-char tracers)
#   - -DCORE_DEBUG -DDEBUG_STDIO: route every dprintf() in core/ and
#     libcom32core/ through printf() so they appear on screen
# Remove all three knobs once the root cause is identified.
# sed -i 's|^; %define DEBUG_TRACERS|%define DEBUG_TRACERS|' ./core/tracers.inc
# sed -i 's|^; %define DEBUG_MESSAGES|%define DEBUG_MESSAGES|' ./core/tracers.inc

CFLAGS="" CXXFLAGS="" LDFLAGS="" DATE=2020 make OPTFLAGS="-Os -Wno-error -fcf-protection=none" bios # -DCORE_DEBUG -DDEBUG_STDIO

# Strip asm-emitted GNU property notes from every built .c32 module.
find ./bios -name '*.c32' -exec objcopy --remove-section=.note.gnu.property {} \;
