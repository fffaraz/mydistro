#!/bin/bash
set -exuo pipefail

cd ./src

[ -d ./gmp ] || (tar xf gmp-*.tar.* && mv gmp-*/ gmp)

[ -d ./mpc ] || (tar xf mpc-*.tar.* && mv mpc-*/ mpc)
if [ -d ./mpc/.git ]; then
	cd ./mpc
	git config --global --add safe.directory $(pwd)
	autoreconf -vif
	cd ..
fi

[ -d ./mpfr ] || (tar xf mpfr-*.tar.* && mv mpfr-*/ mpfr)
if [ -d ./mpfr/.git ]; then
	cd ./mpfr
	./autogen.sh
	cd ..
fi
