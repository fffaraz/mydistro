#!/bin/bash
set -exuo pipefail

cd ./src/glibc

# Work around missing redefinition guards in glibc 2.42's sys/mount.h:
# it pulls in <linux/mount.h> (which now defines OPEN_TREE_CLONE et al.)
# and then unconditionally redefines the same macros, which -Werror rejects.
sed -i -E 's@^(#define (FSMOUNT_CLOEXEC|FSOPEN_CLOEXEC|OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC|MOVE_MOUNT_[A-Z_]+|FSPICK_[A-Z_]+)\b)@#undef \2\n\1@' \
	sysdeps/unix/sysv/linux/sys/mount.h

mkdir build
cd build

../configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
