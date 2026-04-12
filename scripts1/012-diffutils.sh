#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d diffutils ]; then
  tar xf diffutils-*.tar.*
  mv diffutils-*/ diffutils
  cd ./diffutils
else
  cd ./diffutils
  cp -r --reflink=auto ../gnulib ./gnulib-repo
  sed -i "/emit += 'AM_CFLAGS %s.*am_set_or_augment/i\\        emit += 'AM_CFLAGS =\\\\n'" gnulib-repo/pygnulib/GLEmiter.py
  ./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install
