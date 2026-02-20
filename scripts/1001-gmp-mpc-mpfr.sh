#!/bin/bash
set -exuo pipefail

cd ./src

cd gmp
cd ..

cd mpc
autoreconf -vif
cd ..

cd mpfr
./autogen.sh
cd ..
