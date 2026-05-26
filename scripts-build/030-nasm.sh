#!/bin/bash
set -exuo pipefail

cd ./src/nasm

./autogen.sh
./configure --prefix=/usr

make

# nasm's `make install` insists on installing nasm.1/ndisasm.1, but the git
# tree only ships nasm.txt — the .1 files are generated via asciidoc/xmlto,
# which we don't have. Drop empty placeholders so install doesn't abort.
touch nasm.1 ndisasm.1

make install DESTDIR=$INITRAMFS_DIR
