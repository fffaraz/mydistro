#!/bin/bash
set -exuo pipefail

cd ./src/bash

./configure \
	--prefix=/usr \
	--build="$(sh support/config.guess)" \
	--without-bash-malloc

make
make install DESTDIR=$INITRAMFS_DIR
