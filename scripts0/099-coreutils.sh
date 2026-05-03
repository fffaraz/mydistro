#!/bin/bash
set -exuo pipefail

cd ./src/coreutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
rm -f ./gl/top/maint.mk.diff
./bootstrap --skip-po --gnulib-srcdir=./gnulib-repo

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-install-program=hostname --enable-no-install-program=kill,uptime --disable-nls

grep -q '^#include <string.h>' lib/mbbuf.h || sed -i '/^#include "idx.h"/a #include <string.h>' lib/mbbuf.h

make
make install DESTDIR=$INITRAMFS_DIR
