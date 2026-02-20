#!/bin/bash
set -exuo pipefail

cd ./src/diffutils

cp -r --reflink=auto ../gnulib ./gnulib-repo

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install
