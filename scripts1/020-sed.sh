#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d sed ]; then
  tar xf sed-*.tar.*
  mv sed-*/ sed
  cd ./sed
else
  cd ./sed
  cp -r --reflink=auto ../gnulib ./gnulib-repo
  sed -i "/emit += 'AM_CFLAGS %s.*am_set_or_augment/i\\        emit += 'AM_CFLAGS =\\\\n'" gnulib-repo/pygnulib/GLEmiter.py
  ./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install
