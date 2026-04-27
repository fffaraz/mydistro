#!/bin/bash
set -exuo pipefail

cd ./src/util-linux

./autogen.sh

./configure --bindir=/usr/bin \
	--libdir=/usr/lib \
	--runstatedir=/run \
	--sbindir=/usr/sbin \
	--disable-chfn-chsh \
	--disable-login \
	--disable-nologin \
	--disable-su \
	--disable-setpriv \
	--disable-runuser \
	--disable-pylibmount \
	--disable-liblastlog2 \
	--disable-static \
	--without-python \
	--without-systemd \
	--without-systemdsystemunitdir \
	ADJTIME_PATH=/var/lib/hwclock/adjtime

make
make install DESTDIR=$INITRAMFS_DIR
