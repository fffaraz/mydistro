#!/bin/bash
set -exuo pipefail

cd ./src
tar xf make-*.tar.*
mv make-*/ make
cd ./make

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess) \
	--disable-nls

make
make DESTDIR=$LFS install

cd ..
rm -rf ./make
