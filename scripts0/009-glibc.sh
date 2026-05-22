#!/bin/bash
set -exuo pipefail

cd ./src/glibc

mkdir build
cd build

sed -i -E '
  s|^(#define (FSMOUNT_CLOEXEC|FSOPEN_CLOEXEC|OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC|MOVE_MOUNT_[A-Z_]+|FSPICK_[A-Z_]+)\b)|#undef \2\n\1|
' sysdeps/unix/sysv/linux/sys/mount.h

../configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
