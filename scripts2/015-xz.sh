#!/bin/bash
set -exuo pipefail

cd ./src
tar xf xz-*.tar.*
mv xz-*/ xz
cd ./xz

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/xz-5.8.2

make
make check
make install

cd ..
rm -rf ./xz
