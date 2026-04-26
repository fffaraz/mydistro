#!/bin/bash
set -exuo pipefail

cd ./src
tar xf Python-*.tar.*
mv Python-*/ python
cd ./python

./configure --prefix=/usr \
	--enable-shared \
	--without-ensurepip \
	--without-static-libpython

make
make install
