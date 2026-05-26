#!/bin/bash
set -exuo pipefail

# Real mkfs.vfat — pass 2 otherwise falls back to busybox's mkfs_vfat applet,
# which produces a non-standard FAT32 (6 reserved sectors instead of 32) that
# is too fragile for 014-mk-boot-img.sh's syslinux install.

cd ./src/dosfstools

./autogen.sh

./configure --prefix=/usr \
	--enable-compat-symlinks \
	--mandir=/usr/share/man \
	--docdir=/usr/share/doc/dosfstools

make
make install DESTDIR=$INITRAMFS_DIR
make install
