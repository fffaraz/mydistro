#!/bin/bash
set -exuo pipefail

cd ./src/autoconf

cp .prev-version .tarball-version

autoreconf -vif
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
