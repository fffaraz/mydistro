#!/bin/bash
set -exuo pipefail

cd ./src
tar xf iproute2-*.tar.*
mv iproute2-*/ iproute2
cd ./iproute2

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install

install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.18.0

cd ..
rm -rf ./iproute2
