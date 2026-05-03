#!/bin/bash
set -exuo pipefail

cd ./src
tar xf libffi-*.tar.*
mv libffi-*/ libffi
cd ./libffi

./configure --prefix=/usr \
	--disable-static \
	--with-gcc-arch=native

make
make check || true
make install

cd ..
rm -rf ./libffi
