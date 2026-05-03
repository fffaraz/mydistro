#!/bin/bash
set -exuo pipefail

cd ./src
tar xf tar-*.tar.*
mv tar-*/ tar
cd ./tar

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr

make
make check || true
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

cd ..
rm -rf ./tar
