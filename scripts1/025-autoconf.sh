#!/bin/bash
set -exuo pipefail

cd ./src
[ -d autoconf ] || (tar xf autoconf-*.tar.* && mv autoconf-*/ autoconf)
cd ./autoconf

cp .prev-version .tarball-version

./bootstrap
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
