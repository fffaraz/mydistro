#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d glibc ]; then
	tar xf glibc-*.tar.*
	mv glibc-*/ glibc
	cd ./glibc
	patch -Np1 -i ../glibc-fhs-1.patch
else
	cd ./glibc
fi

case $(uname -m) in
i?86)
	ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
	;;
x86_64)
	ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
	ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
	;;
esac

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" >configparms

../configure \
	--prefix=/usr \
	--host=$LFS_TGT \
	--build=$(../scripts/config.guess) \
	--disable-nscd \
	libc_cv_slibdir=/usr/lib \
	--enable-kernel=5.4

make
make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &>dummy.log
readelf -l a.out | grep ': /lib'

rm -v a.out dummy.log
