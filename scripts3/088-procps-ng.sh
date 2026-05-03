#!/bin/bash
set -exuo pipefail

cd ./src
tar xf procps-ng-*.tar.*
mv procps-ng-*/ procps-ng
cd ./procps-ng

./configure --prefix=/usr \
	--docdir=/usr/share/doc/procps-ng-4.0.6 \
	--disable-static \
	--disable-kill \
	--enable-watch8bit \
	--with-systemd

make
make install

cd ..
rm -rf ./procps-ng
