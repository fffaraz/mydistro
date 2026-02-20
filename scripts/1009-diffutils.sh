#!/bin/bash
set -exuo pipefail

cd ./src/diffutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
sed -i '/echo "AM_CFLAGS .*am_set_or_augment/i\  if test "$am_set_or_augment" = "+="; then echo "AM_CFLAGS ="; fi' gnulib-repo/gnulib-tool.sh

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install
