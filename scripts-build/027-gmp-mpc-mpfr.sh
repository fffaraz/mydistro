#!/usr/bin/bash
set -exuo pipefail

cd ./src

# gmp ships as a tarball; mpc and mpfr come from git.
tar xf gmp-*.tar.*
mv gmp-*/ gmp

# Build and install gmp (shared lib needed at runtime by coreutils' expr/factor).
cd gmp
# ./configure --prefix=/usr --enable-shared --enable-fat
# make
# make install DESTDIR=$INITRAMFS_DIR
cd ..

# Build and install mpfr (depends on gmp).
cd mpfr
./autogen.sh
# ./configure --prefix=/usr --enable-shared
# make
# make install DESTDIR=$INITRAMFS_DIR
cd ..

# Build and install mpc (depends on gmp + mpfr).
cd mpc
autoreconf -vif
# ./configure --prefix=/usr --enable-shared
# make
# make install DESTDIR=$INITRAMFS_DIR
cd ..
