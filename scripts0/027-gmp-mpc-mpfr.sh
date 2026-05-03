#!/bin/bash
set -exuo pipefail

cd ./src

# gmp ships as a tarball; mpc and mpfr come from git.
tar xf gmp-*.tar.*
mv gmp-*/ gmp

# Build and install mpfr (depends on gmp).
cd mpfr
./autogen.sh
cd ..

# Build and install mpc (depends on gmp + mpfr).
cd mpc
autoreconf -vif
