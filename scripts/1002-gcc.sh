#!/bin/bash
set -x

cd ./src/gcc

ln -s ../gmp gmp
ln -s ../mpc mpc
ln -s ../mpfr mpfr

if [ $(uname -m) = "x86_64" ]; then
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
fi

mkdir -v build
cd build

../configure \
    --target=x86_64-mydistro-linux-gnu \
    --prefix=/opt/mydistro/initramfs-dir/tools \
    --with-glibc-version=2.42 \
    --with-sysroot=/opt/mydistro/initramfs-dir \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make -j$(nproc)
make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $(/opt/mydistro/initramfs-dir/tools/bin/x86_64-mydistro-linux-gnu-gcc -print-libgcc-file-name)`/include/limits.h
