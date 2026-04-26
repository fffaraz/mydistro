#!/bin/bash
set -exuo pipefail

cd ./src
tar xf man-db-*.tar.*
mv man-db-*/ man-db
cd ./man-db

./configure --prefix=/usr \
	--docdir=/usr/share/doc/man-db-2.13.1 \
	--sysconfdir=/etc \
	--disable-setuid \
	--enable-cache-owner=bin \
	--with-browser=/usr/bin/lynx \
	--with-vgrind=/usr/bin/vgrind \
	--with-grap=/usr/bin/grap

make
make check
make install

cd ..
rm -rf ./man-db
