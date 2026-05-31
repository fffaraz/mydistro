#!/bin/bash
set -exuo pipefail

cd ./src/openssl

./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib --docdir=/tmp/openssl-doc shared

make
make install DESTDIR=$INITRAMFS_DIR
make install
