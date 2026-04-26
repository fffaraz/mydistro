#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gettext-*.tar.*
mv gettext-*/ gettext
cd ./gettext

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/gettext-1.0

make
make check

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd ..
rm -rf ./gettext
