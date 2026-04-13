#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d gawk ]; then
	tar xf gawk-*.tar.*
	mv gawk-*/ gawk
	cd ./gawk
else
	cd ./gawk
	ln -sf "$(which aclocal)" /usr/local/bin/aclocal-1.16
	ln -sf "$(which automake)" /usr/local/bin/automake-1.16
fi

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
