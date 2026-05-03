#!/bin/bash
set -exuo pipefail

cd ./src
tar xf kmod-*.tar.*
mv kmod-*/ kmod
cd ./kmod

mkdir -p build
cd build

meson setup --prefix=/usr .. \
	--buildtype=release \
	-D manpages=false

ninja
ninja install

cd ../..
rm -rf ./kmod
