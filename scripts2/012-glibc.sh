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

mkdir -v build
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

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make install

sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

localedef -i C -f UTF-8 C.UTF-8
make localedata/install-locales

cp ../../assets/etc/nsswitch.conf /etc/nsswitch.conf

# Adding Time Zone Data

tar -xf ../../tzdata2025c.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica \
	asia australasia backward; do
	zic -L /dev/null -d $ZONEINFO ${tz}
	zic -L /dev/null -d $ZONEINFO/posix ${tz}
	zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO tz

tzselect

ln -sfv /usr/share/zoneinfo/America/New_York /etc/localtime

# Configuring the Dynamic Loader
cp ../../assets/etc/ld.so.conf /etc/ld.so.conf
mkdir -pv /etc/ld.so.conf.d
