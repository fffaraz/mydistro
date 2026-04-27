#!/bin/bash
set -exuo pipefail

cd ./src

rm -rf ./iana-etc
tar xf iana-etc.tar.gz
mv iana-etc-*/ iana-etc

cd ./iana-etc

mkdir -p $INITRAMFS_DIR/etc
cp -v services protocols $INITRAMFS_DIR/etc/
