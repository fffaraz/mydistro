#!/bin/bash
set -exuo pipefail

cd ./src
tar xf expat-*.tar.*
mv expat-*/ expat
cd ./expat

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/expat-2.7.4

make
make check || true
make install

install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.4

cd ..
rm -rf ./expat
