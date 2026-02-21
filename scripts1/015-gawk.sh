#!/bin/bash
set -exuo pipefail

cd ./src/gawk

ln -sf "$(which aclocal)" /usr/local/bin/aclocal-1.16
ln -sf "$(which automake)" /usr/local/bin/automake-1.16

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
