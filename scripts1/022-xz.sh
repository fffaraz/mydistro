#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d xz ]; then
  tar xf xz-*.tar.*
  mv xz-*/ xz
  cd ./xz
else
  cd ./xz
  autoreconf -vif
fi

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.2

make
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la
