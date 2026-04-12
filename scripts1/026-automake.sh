#!/bin/bash
set -exuo pipefail

cd ./src
[ -d automake ] || (tar xf automake-*.tar.* && mv automake-*/ automake)
cd ./automake

./bootstrap
./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
