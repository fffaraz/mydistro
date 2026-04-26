#!/bin/bash
set -exuo pipefail

cd ./src
tar xf Python-*.tar.*
mv Python-*/ python
cd ./python

./configure --prefix=/usr \
	--enable-shared \
	--with-system-expat \
	--enable-optimizations \
	--without-static-libpython

make

# make test TESTOPTS="--timeout 120" || true

make install

cat > /etc/pip.conf << "EOF"
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

install -v -dm755 /usr/share/doc/python-3.14.3/html

tar --strip-components=1 \
    --no-same-owner \
    --no-same-permissions \
    -C /usr/share/doc/python-3.14.3/html \
    -xvf ../python-3.14.3-docs-html.tar.bz2

cd ..
rm -rf ./python
