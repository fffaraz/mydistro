#!/bin/bash
set -exuo pipefail

cd ./src/inetutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

./configure --prefix=/usr \
	--bindir=/usr/bin \
	--localstatedir=/var \
	--disable-logger \
	--disable-whois \
	--disable-rcp \
	--disable-rexec \
	--disable-rlogin \
	--disable-rsh \
	--disable-servers \
	--disable-nls

make
make install DESTDIR=$INITRAMFS_DIR

# LFS moves ifconfig from /usr/bin to /usr/sbin
if [ -e $INITRAMFS_DIR/usr/bin/ifconfig ]; then
	mv -v $INITRAMFS_DIR/usr/bin/ifconfig $INITRAMFS_DIR/usr/sbin/ifconfig
fi
