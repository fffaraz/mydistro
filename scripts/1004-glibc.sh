#!/bin/bash
set -x

cd ./src/glibc

case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 /opt/mydistro/initramfs-dir/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 /opt/mydistro/initramfs-dir/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /opt/mydistro/initramfs-dir/lib64/ld-lsb-x86-64.so.3
    ;;
esac

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=x86_64-mydistro-linux-gnu   \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4

make -j$(nproc)
make DESTDIR=/opt/mydistro/initramfs-dir install

sed '/RTLDLIST=/s@/usr@@g' -i /opt/mydistro/initramfs-dir/usr/bin/ldd

../libstdc++-v3/configure      \
    --host=x86_64-mydistro-linux-gnu   \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/x86_64-mydistro-linux-gnu/include/c++/15.2.0
