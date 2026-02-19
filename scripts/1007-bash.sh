#!/bin/bash
set -x

cd ./src/bash

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make -j$(nproc)
make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh
