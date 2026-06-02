#!/usr/bin/bash
set -exuo pipefail

# busybox (which supplied the cpio applet) is disabled, and nothing else in the
# build provides cpio. 012-initramfs.sh needs it to pack the initramfs, so build
# GNU cpio and ship it in the image. Pass 1's debian base still has its own cpio;
# this matters for pass 2, whose build container is pass 1's initramfs.

cd ./src/cpio

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

# cpio declares `extern int (*xstat) ();` with an empty parameter list. Under
# C23 (GCC 15's default) that means "takes no arguments", turning the stat/lstat
# assignments and 2-arg calls into hard errors that -Wno-error can't downgrade.
# Build against the older C17 semantics where `()` means "unspecified args".
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --disable-nls CFLAGS="$CFLAGS -std=gnu17"

make
make install DESTDIR=$INITRAMFS_DIR
