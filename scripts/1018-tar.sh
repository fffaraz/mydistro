#!/bin/bash
set -exuo pipefail

cd ./src/tar

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
