#!/bin/bash
set -exuo pipefail

cd ./src/gawk

# Some upstream Makefile.in references aclocal-1.16/automake-1.16; provide
# shims that point at whichever versions are installed in the build image.
ln -sf "$(which aclocal)" /usr/local/bin/aclocal-1.16
ln -sf "$(which automake)" /usr/local/bin/automake-1.16

./bootstrap.sh

./configure --prefix=/usr --disable-nls --disable-mpfr

make
make install DESTDIR=$INITRAMFS_DIR

ln -sfv gawk $INITRAMFS_DIR/usr/bin/awk
