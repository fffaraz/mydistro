#!/bin/bash
set -exuo pipefail

./scripts/version-check.sh

mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

export LC_ALL=POSIX
export LFS=$(pwd)/rootfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH="$LFS/tools/bin:$PATH"
export CONFIG_SITE=$LFS/usr/share/config.site
export MAKEFLAGS=-j$(nproc)
export TERM=xterm-256color

COMMON_FLAGS="-O3 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

./scripts/001-fs.sh
./scripts/002-binutils-1.sh
./scripts/003-gcc-1.sh
./scripts/004-linux-headers.sh
./scripts/005-glibc.sh
./scripts/006-libstdc.sh
./scripts/007-m4.sh
./scripts/008-ncurses.sh
./scripts/009-bash.sh
./scripts/010-coreutils.sh
./scripts/011-diffutils.sh
./scripts/012-file.sh
./scripts/013-findutils.sh
./scripts/014-gawk.sh
./scripts/015-grep.sh
./scripts/016-gzip.sh
./scripts/017-make.sh
./scripts/018-patch.sh
./scripts/019-sed.sh
./scripts/020-tar.sh
./scripts/021-xz.sh
./scripts/022-binutils-2.sh
./scripts/023-gcc-2.sh
./scripts/024-export.sh
