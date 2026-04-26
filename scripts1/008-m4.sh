#!/bin/bash
set -exuo pipefail

cd ./src
tar xf m4-*.tar.*
mv m4-*/ m4
cd ./m4

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
