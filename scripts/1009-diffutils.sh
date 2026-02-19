#!/bin/bash
set -x

cd ./src/diffutils

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make -j$(nproc)
make DESTDIR=$LFS install
