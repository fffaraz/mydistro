#!/bin/bash
set -exuo pipefail

cd ./src
tar xf flex-*.tar.*
mv flex-*/ flex
cd ./flex

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/flex-2.6.4

make
make check || true
make install

ln -sv flex /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

cd ..
rm -rf ./flex
