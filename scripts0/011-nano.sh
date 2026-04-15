#!/bin/bash
set -exuo pipefail

cd ./src/nano

# ln -s ../gnulib ./gnulib
cp -r --reflink=auto ../gnulib ./gnulib

./autogen.sh
./configure --enable-utf8 --enable-year2038 --disable-nls --docdir=/tmp/nano-doc --mandir=/tmp/nano-man --infodir=/tmp/nano-info
make
make install DESTDIR=/opt/mydistro/initramfs-dir

# install terminfo entries so ncurses can initialize the terminal
mkdir -p /opt/mydistro/initramfs-dir/usr/share/terminfo/x
mkdir -p /opt/mydistro/initramfs-dir/usr/share/terminfo/l
cp /usr/share/terminfo/x/xterm-256color /opt/mydistro/initramfs-dir/usr/share/terminfo/x/
cp /usr/share/terminfo/x/xterm /opt/mydistro/initramfs-dir/usr/share/terminfo/x/
cp /usr/share/terminfo/l/linux /opt/mydistro/initramfs-dir/usr/share/terminfo/l/
