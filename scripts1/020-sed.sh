#!/bin/bash
set -exuo pipefail

cd ./src/sed

cp -r --reflink=auto ../gnulib ./gnulib-repo
sed -i "/emit += 'AM_CFLAGS %s.*am_set_or_augment/i\\        emit += 'AM_CFLAGS =\\\\n'" gnulib-repo/pygnulib/GLEmiter.py

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess) \
            CFLAGS="-Wno-error=deprecated-declarations -Wno-error=analyzer-use-of-uninitialized-value"

make
make DESTDIR=$LFS install
