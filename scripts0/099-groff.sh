#!/bin/bash
set -exuo pipefail

cd ./src/groff

./bootstrap

PAGE=letter ./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
