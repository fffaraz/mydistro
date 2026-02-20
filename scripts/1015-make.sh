#!/bin/bash
set -exuo pipefail

cd ./src/make

cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

sed -i '1i #define streq(s1, s2) (strcmp(s1, s2) == 0)' lib/concat-filename.c lib/findprog-in.c

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) \
            --disable-nls

make
make DESTDIR=$LFS install
