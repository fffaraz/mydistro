#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d grep ]; then
	tar xf grep-*.tar.*
	mv grep-*/ grep
	cd ./grep
else
	cd ./grep
	cp -r --reflink=auto ../gnulib ./gnulib-repo
	./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install
