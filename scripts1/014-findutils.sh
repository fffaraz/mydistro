#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d findutils ]; then
  tar xf findutils-*.tar.*
  mv findutils-*/ findutils
  cd ./findutils
else
  cd ./findutils
  cp -r --reflink=auto ../gnulib ./gnulib-repo
  ./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
