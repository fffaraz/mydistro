#!/bin/bash
set -exuo pipefail

cd ./src/make
cp -r --reflink=auto ../gnulib ./gnulib
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib
sed -i '1i #define streq(s1, s2) (strcmp(s1, s2) == 0)' lib/concat-filename.c lib/findprog-in.c

./configure --disable-nls
make
make install DESTDIR=$INITRAMFS_DIR
