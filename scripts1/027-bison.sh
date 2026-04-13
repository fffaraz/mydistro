#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d bison ]; then
	tar xf bison-*.tar.*
	mv bison-*/ bison
	cd ./bison
else
	cd ./bison
	git config --global --add safe.directory $(pwd)

	rmdir ./submodules/autoconf
	ln -s ../../autoconf ./submodules/autoconf

	rmdir ./gnulib
	cp -r --reflink=auto ../gnulib ./gnulib

	./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

	sed -i '/\/\* directory \*\/ NULL,/a\ NULL,' src/output.c src/print-xml.c
fi

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--disable-nls \
	--docdir=/usr/share/doc/bison-3.8.2

make
make DESTDIR=$LFS install
