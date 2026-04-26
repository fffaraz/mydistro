#!/bin/bash
set -exuo pipefail

cd ./src
tar xf attr-*.tar.*
mv attr-*/ attr
cd ./attr

./configure --prefix=/usr \
	--disable-static \
	--sysconfdir=/etc \
	--docdir=/usr/share/doc/attr-2.5.2

make
make check
make install

cd ..
rm -rf ./attr
