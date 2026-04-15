#!/bin/bash
set -exuo pipefail

cd ./src/autoconf
cp .prev-version .tarball-version
./bootstrap

./configure
make
make install DESTDIR=$INITRAMFS_DIR
