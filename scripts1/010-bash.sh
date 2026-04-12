#!/bin/bash
set -exuo pipefail

cd ./src
[ -d bash ] || (tar xf bash-*.tar.* && mv bash-*/ bash)
cd ./bash

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make
make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh
