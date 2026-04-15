#!/bin/bash
set -exuo pipefail

cd ./src/nano

# ln -s ../gnulib ./gnulib
cp -r --reflink=auto ../gnulib ./gnulib

./autogen.sh
./configure --prefix=/usr --enable-utf8 --enable-year2038 --disable-nls --docdir=/tmp/nano-doc --mandir=/tmp/nano-man --infodir=/tmp/nano-info
make
make install DESTDIR=$INITRAMFS_DIR

# install terminfo entries so ncurses can initialize the terminal
mkdir -p $INITRAMFS_DIR/usr/share/terminfo/x
mkdir -p $INITRAMFS_DIR/usr/share/terminfo/l
cp /usr/share/terminfo/x/xterm-256color $INITRAMFS_DIR/usr/share/terminfo/x/
cp /usr/share/terminfo/x/xterm $INITRAMFS_DIR/usr/share/terminfo/x/
cp /usr/share/terminfo/l/linux $INITRAMFS_DIR/usr/share/terminfo/l/
