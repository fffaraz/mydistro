#!/bin/bash
set -exuo pipefail

cd ./src
tar xf acl-*.tar.*
mv acl-*/ acl
cd ./acl

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/acl-2.3.2

make
make check || true
make install

cd ..
rm -rf ./acl
