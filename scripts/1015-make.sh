#!/bin/bash
set -exuo pipefail

cd ./src/make

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
