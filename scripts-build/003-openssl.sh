#!/bin/bash
set -exuo pipefail

cd ./src/openssl

./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared

make
make install_sw DESTDIR=$INITRAMFS_DIR
make install_sw
