#!/bin/bash
set -exuo pipefail

cd ./src/bison

git config --global --add safe.directory $(pwd)

rmdir ./submodules/autoconf
ln -s ../../autoconf ./submodules/autoconf

cp -r --reflink=auto ../gnulib ./gnulib-repo

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

sed -i '/\/\* directory \*\/ NULL,/a\                            /* prog_path_override */ NULL,' src/output.c src/print-xml.c

./configure --prefix=/usr \
            --host=$LFS_TGT \
            --disable-nls \
            --docdir=/usr/share/doc/bison-3.8.2

make
make DESTDIR=$LFS install
