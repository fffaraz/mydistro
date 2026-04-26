#!/bin/bash
set -exuo pipefail

cd ./src
tar xf zlib-*.tar.*
mv zlib-*/ zlib
cd zlib

./configure --prefix=/usr
make
make check
make install

rm -fv /usr/lib/libz.a
