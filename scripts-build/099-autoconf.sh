#!/bin/bash
set -exuo pipefail

cd ./src/autoconf

cp .prev-version .tarball-version
./bootstrap

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
