#!/bin/bash
set -exuo pipefail

cd ./src
tar xf patch-*.tar.*
mv patch-*/ patch
cd ./patch

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
