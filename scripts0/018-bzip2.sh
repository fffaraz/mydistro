#!/bin/bash
set -exuo pipefail

cd ./src/bzip2

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

make
make PREFIX=$INITRAMFS_DIR/usr install

cp -av libbz2.so.* $INITRAMFS_DIR/usr/lib/
ln -sfv libbz2.so.1.0.8 $INITRAMFS_DIR/usr/lib/libbz2.so
ln -sfv libbz2.so.1.0.8 $INITRAMFS_DIR/usr/lib/libbz2.so.1

cp -fv bzip2-shared $INITRAMFS_DIR/usr/bin/bzip2
for i in bzcat bunzip2; do
	ln -sfv bzip2 $INITRAMFS_DIR/usr/bin/$i
done

rm -fv $INITRAMFS_DIR/usr/lib/libbz2.a
