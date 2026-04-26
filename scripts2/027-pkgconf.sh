#!/bin/bash
set -exuo pipefail

cd ./src
tar xf pkgconf-*.tar.*
mv pkgconf-*/ pkgconf
cd ./pkgconf

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/pkgconf-2.5.1

make
make install

ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

cd ..
rm -rf ./pkgconf
