#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d autoconf ]; then
	tar xf autoconf-*.tar.*
	mv autoconf-*/ autoconf
	cd ./autoconf
else
	cd ./autoconf
	cp .prev-version .tarball-version
	./bootstrap
fi

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
