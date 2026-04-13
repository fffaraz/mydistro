#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d gmp ]; then
	tar xf gmp-*.tar.* && mv gmp-*/ gmp
fi

if [ ! -d mpc ]; then
	tar xf mpc-*.tar.* && mv mpc-*/ mpc
else
	cd mpc
	git config --global --add safe.directory $(pwd)
	autoreconf -vif
	cd ..
fi

if [ ! -d mpfr ]; then
	tar xf mpfr-*.tar.* && mv mpfr-*/ mpfr
else
	cd mpfr
	./autogen.sh
	cd ..
fi
