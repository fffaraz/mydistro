#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d patch ]; then
	tar xf patch-*.tar.*
	mv patch-*/ patch
	cd ./patch
else
	cd ./patch
	cp -r --reflink=auto ../gnulib ./gnulib-repo
	./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
