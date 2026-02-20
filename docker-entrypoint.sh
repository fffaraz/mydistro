#!/bin/bash
set -exuo pipefail

cd /opt/mydistro

# cp -r --reflink=auto ./src-ro ./src
mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

# ./scripts/0001-kernel.sh
# ./scripts/0002-initramfs.sh
# ./scripts/0004-busybox.sh
# ./scripts/0005-syslinux.sh
# ./scripts/0006-memtest86.sh
# ./scripts/0007-microwindows.sh
# ./scripts/0008-dropbear.sh
# ./scripts/0010-curl.sh
# ./scripts/0011-nano.sh
# ./scripts/0012-initramfs.sh
# ./scripts/0013-mkisofs.sh
# ./scripts/0014-mk-boot-img.sh

./scripts/0002-initramfs.sh

export LC_ALL=POSIX
export LFS=/opt/mydistro/initramfs-dir
export LFS_TGT=$(uname -m)-mydistro-linux-gnu
export PATH="$LFS/tools/bin:$PATH"
export CONFIG_SITE=$LFS/usr/share/config.site
export MAKEFLAGS=-j$(nproc)

./scripts/1001-binutils-1.sh
./scripts/1002-gcc-1.sh
./scripts/1003-linux-headers.sh
./scripts/1004-glibc.sh
./scripts/1005-libstdc.sh
./scripts/1005-m4.sh
./scripts/1006-ncurses.sh
./scripts/1007-bash.sh
./scripts/1008-coreutils.sh
./scripts/1009-diffutils.sh
./scripts/1010-file.sh
./scripts/1011-findutils.sh
./scripts/1012-gawk.sh
./scripts/1013-grep.sh
./scripts/1014-gzip.sh
./scripts/1015-make.sh
./scripts/1016-patch.sh
./scripts/1017-sed.sh
./scripts/1018-tar.sh
./scripts/1019-xz.sh
./scripts/1020-binutils-2.sh
./scripts/1021-gcc-2.sh
