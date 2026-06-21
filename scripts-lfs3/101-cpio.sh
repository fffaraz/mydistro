#!/usr/bin/bash
set -exuo pipefail

cd ./src
tar xf cpio-*.tar.*
mv cpio-*/ cpio
cd ./cpio

# Workaround for a build failure shown by gcc15 (BLFS).
sed -e "/^extern int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
	-i src/extern.h
sed -e "/^int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
	-i src/global.c

./configure --prefix=/usr --enable-mt --with-rmt=/usr/libexec/rmt

make

# makeinfo --html            -o doc/html      doc/cpio.texi
# makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi
# makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi

make check || true
make install

cd ..
rm -rf ./cpio
