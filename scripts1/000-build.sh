#!/bin/bash
set -exuo pipefail

cd /opt/mydistro

mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

export LC_ALL=POSIX
export LFS=$(pwd)/rootfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH="$LFS/tools/bin:$PATH"
export CONFIG_SITE=$LFS/usr/share/config.site
export MAKEFLAGS=-j$(nproc)
export TERM=xterm-256color

./scripts/001-fs.sh
./scripts/002-gmp-mpc-mpfr.sh
./scripts/003-binutils-1.sh
./scripts/004-gcc-1.sh
./scripts/005-linux-headers.sh
./scripts/006-glibc.sh
./scripts/007-libstdc.sh
./scripts/008-m4.sh
./scripts/009-ncurses.sh
./scripts/010-bash.sh
./scripts/011-coreutils.sh
./scripts/012-diffutils.sh
./scripts/013-file.sh
./scripts/014-findutils.sh
./scripts/015-gawk.sh
./scripts/016-grep.sh
./scripts/017-gzip.sh
./scripts/018-make.sh
./scripts/019-patch.sh
./scripts/020-sed.sh
./scripts/021-tar.sh
./scripts/022-xz.sh
./scripts/023-binutils-2.sh
./scripts/024-gcc-2.sh
./scripts/025-automake.sh
./scripts/026-export.sh
