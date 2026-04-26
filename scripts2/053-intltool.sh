#!/bin/bash
set -exuo pipefail

cd ./src
tar xf intltool-*.tar.*
mv intltool-*/ intltool
cd ./intltool

sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make
make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

cd ..
rm -rf ./intltool
