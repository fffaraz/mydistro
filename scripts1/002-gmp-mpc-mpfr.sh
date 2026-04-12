#!/bin/bash
set -exuo pipefail

cd ./src

[ -d gmp ] || (tar xf gmp-*.tar.* && mv gmp-*/ gmp)
cd gmp
# configure script already exists
cd ..

[ -d mpc ] || (tar xf mpc-*.tar.* && mv mpc-*/ mpc)
cd mpc
git config --global --add safe.directory $(pwd)
autoreconf -vif
cd ..

[ -d mpfr ] || (tar xf mpfr-*.tar.* && mv mpfr-*/ mpfr)
cd mpfr
./autogen.sh
cd ..
