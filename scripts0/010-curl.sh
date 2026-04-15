#!/bin/bash
set -exuo pipefail

cd ./src/curl

autoreconf -vif

./configure --without-libpsl --without-brotli --with-openssl

make
make install DESTDIR=$INITRAMFS_DIR
