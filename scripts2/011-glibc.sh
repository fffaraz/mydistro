#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d glibc ]; then
	tar -xf glibc-*.tar.xz
	mv glibc-*/ glibc
	cd ./glibc
else
	cd ./glibc
fi

mkdir -p build
cd build

echo "rootsbindir=/usr/sbin" >configparms

../configure --prefix=/usr \
	--disable-werror \
	--disable-nscd \
	libc_cv_slibdir=/usr/lib \
	--enable-stack-protector=strong \
	--enable-kernel=5.4

make
make check
make install

sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

localedef -i C -f UTF-8 C.UTF-8

make localedata/install-locales

cp /opt/mydistro/assets/nsswitch.conf /etc/nsswitch.conf
