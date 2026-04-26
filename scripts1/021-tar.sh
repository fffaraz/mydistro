#!/bin/bash
set -exuo pipefail

cd ./src
tar xf tar-*.tar.*
mv tar-*/ tar
cd ./tar

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess) \
	--disable-nls

make
make DESTDIR=$LFS install

cd ..
rm -rf ./tar
