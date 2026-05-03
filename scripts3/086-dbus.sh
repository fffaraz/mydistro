#!/bin/bash
set -exuo pipefail

cd ./src
tar xf dbus-*.tar.*
mv dbus-*/ dbus
cd ./dbus

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..

ninja
ninja test
ninja install

ln -sfv /etc/machine-id /var/lib/dbus

cd ../..
rm -rf ./dbus
