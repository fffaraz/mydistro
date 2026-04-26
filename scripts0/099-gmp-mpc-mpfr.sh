#!/bin/bash
set -exuo pipefail

cd ./src

tar xf gmp-*.tar.*
mv gmp-*/ gmp

cd ./mpc
autoreconf -vif
cd ..

cd ./mpfr
./autogen.sh
cd ..
