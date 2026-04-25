#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d m4 ]; then
	tar xf m4-*.tar.*
	mv m4-*/ m4
	cd ./m4
else
	cd ./m4
	cp -r --reflink=auto ../gnulib ./gnulib-repo
	./bootstrap --skip-po --skip-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
