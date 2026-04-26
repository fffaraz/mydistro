#!/bin/bash
set -exuo pipefail

cd ./src
tar xf automake-*.tar.*
mv automake-*/ automake
cd ./automake

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

cd ..
rm -rf ./automake
