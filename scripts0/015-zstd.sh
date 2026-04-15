#!/bin/bash
set -exuo pipefail

cd ./src/zstd

make PREFIX=/usr
make install PREFIX=/usr DESTDIR=$INITRAMFS_DIR
