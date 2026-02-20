#!/bin/bash
set -exuo pipefail

cd ./src

cd gmp
cd ..

cd mpc
git config --global --add safe.directory $(pwd)
autoreconf -vif
cd ..

cd mpfr
./autogen.sh
cd ..
