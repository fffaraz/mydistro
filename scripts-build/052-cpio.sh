#!/usr/bin/bash
set -exuo pipefail

# busybox (which supplied the cpio applet) is disabled, and nothing else in the
# build provides cpio. 012-initramfs.sh needs it to pack the initramfs, so build
# GNU cpio and ship it in the image. Pass 1's debian base still has its own cpio;
# this matters for pass 2, whose build container is pass 1's initramfs.

cd ./src/cpio

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
