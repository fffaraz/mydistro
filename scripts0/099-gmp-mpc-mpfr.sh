#!/bin/bash
set -exuo pipefail

cd ./src

# gmp ships as a tarball; mpc and mpfr come from git.
tar xf gmp-*.tar.*
mv gmp-*/ gmp

# Build and install gmp.
pushd gmp
sed -i '/long long t1;/,+1s/()/(...)/' configure
./configure --prefix=/usr --enable-cxx --disable-static
make
make install DESTDIR=$INITRAMFS_DIR
popd

# Build and install mpfr (depends on gmp).
pushd mpfr
./autogen.sh
./configure --prefix=/usr --disable-static --enable-thread-safe
make
make install DESTDIR=$INITRAMFS_DIR
popd

# Build and install mpc (depends on gmp + mpfr).
pushd mpc
autoreconf -vif
./configure --prefix=/usr --disable-static
make
make install DESTDIR=$INITRAMFS_DIR
popd
