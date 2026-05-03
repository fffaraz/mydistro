#!/bin/bash
set -exuo pipefail

cd ./src/findutils
cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr --localstatedir=/var/lib/locate --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
