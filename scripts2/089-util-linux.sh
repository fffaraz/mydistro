#!/bin/bash
set -exuo pipefail

cd ./src
tar xf util-linux-*.tar.*
mv util-linux-*/ util-linux
cd ./util-linux

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
	ADJTIME_PATH=/var/lib/hwclock/adjtime \
	--docdir=/usr/share/doc/util-linux-2.41.3

make
make install

cd ..
rm -rf ./util-linux
