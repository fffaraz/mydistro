#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d python ]; then
	tar xf Python-*.tar.*
	mv Python-*/ python
	cd ./python
else
	cd ./python
fi

./configure --prefix=/usr \
	--enable-shared \
	--without-ensurepip \
	--without-static-libpython

make
make install
