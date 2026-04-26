#!/bin/bash
set -exuo pipefail

cd ./src
tar xf grub-*.tar.*
mv grub-*/ grub
cd ./grub

unset {C,CPP,CXX,LD}FLAGS

sed 's/--image-base/--nonexist-linker-option/' -i configure

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-efiemu \
	--disable-werror

make
make install

cd ..
rm -rf ./grub
