#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d texinfo ]; then
	tar xf texinfo-*.tar.*
	mv texinfo-*/ texinfo
	cd ./texinfo
else
	cd ./texinfo
fi

./configure --prefix=/usr
make
make install
