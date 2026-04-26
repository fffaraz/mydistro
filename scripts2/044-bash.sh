#!/bin/bash
set -exuo pipefail

cd ./src
tar xf bash-*.tar.*
mv bash-*/ bash
cd ./bash

./configure --prefix=/usr \
	--without-bash-malloc \
	--with-installed-readline \
	--docdir=/usr/share/doc/bash-5.3

make
make install

cd ..
rm -rf ./bash
