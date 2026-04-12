#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d gmp ]; then
  tar xf gmp-*.tar.* && mv gmp-*/ gmp
fi
cd gmp
# configure script already exists
cd ..

if [ ! -d mpc ]; then
  tar xf mpc-*.tar.* && mv mpc-*/ mpc
fi
cd mpc
git config --global --add safe.directory $(pwd)
autoreconf -vif
cd ..

if [ ! -d mpfr ]; then
  tar xf mpfr-*.tar.* && mv mpfr-*/ mpfr
fi
cd mpfr
./autogen.sh
cd ..
