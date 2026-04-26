#!/bin/bash
set -exuo pipefail

cd ./src
tar xf grep-*.tar.*
mv grep-*/ grep
cd ./grep

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install

cd ..
rm -rf ./grep
