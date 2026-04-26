#!/bin/bash
set -exuo pipefail

cd ./src/bison

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

# sed -i '/\/\* directory \*\/ NULL,/a\ NULL,' src/output.c src/print-xml.c

./configure --disable-nls --disable-shared

make
make install DESTDIR=$INITRAMFS_DIR
