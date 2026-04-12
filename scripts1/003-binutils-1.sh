#!/bin/bash
set -exuo pipefail

cd ./src

if [ ! -d binutils ]; then
  tar xf binutils-*.tar.* && mv binutils-*/ binutils
  cd ./binutils
else
  cd ./binutils
  ln -s ../gmp gmp
  ln -s ../mpfr mpfr
fi

mkdir -v build
cd build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make
make install
