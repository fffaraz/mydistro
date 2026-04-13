#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d gzip ]; then
	tar xf gzip-*.tar.*
	mv gzip-*/ gzip
	cd ./gzip
else
	cd ./gzip
	cp -r --reflink=auto ../gnulib ./gnulib-repo
	./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
fi

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
