#!/bin/bash
set -exuo pipefail

cd ./src
tar xf libtool-*.tar.*
mv libtool-*/ libtool
cd ./libtool

./configure --prefix=/usr

make
make check || true
make install

rm -fv /usr/lib/libltdl.a

cd ..
rm -rf ./libtool
