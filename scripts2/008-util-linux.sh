#!/bin/bash
set -exuo pipefail

cd ./src
tar xf util-linux-*.tar.*
mv util-linux-*/ util-linux
cd ./util-linux

mkdir -pv /var/lib/hwclock

./configure --libdir=/usr/lib \
	--runstatedir=/run \
	--disable-chfn-chsh \
	--disable-login \
	--disable-nologin \
	--disable-su \
	--disable-setpriv \
	--disable-runuser \
	--disable-pylibmount \
	--disable-static \
	--disable-liblastlog2 \
	--without-python \
	ADJTIME_PATH=/var/lib/hwclock/adjtime \
	--docdir=/usr/share/doc/util-linux-2.41.3

make
make install
