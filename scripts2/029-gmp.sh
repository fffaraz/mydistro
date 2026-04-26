#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gmp-*.tar.*
mv gmp-*/ gmp
cd ./gmp

sed -i '/long long t1;/,+1s/()/(...)/' configure

./configure --prefix=/usr \
	--enable-cxx \
	--disable-static \
	--docdir=/usr/share/doc/gmp-6.3.0

make
make html

make check 2>&1 | tee gmp-check-log || true
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

cd ..
rm -rf ./gmp
