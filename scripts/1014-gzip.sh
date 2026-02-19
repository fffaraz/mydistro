#!/bin/bash
set -x

cd ./src/gzip

./configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
