#!/bin/bash
set -exuo pipefail

cd /opt/mydistro

mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

COMMON_FLAGS="-O3 -pipe -march=native -static -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"
export LDFLAGS="-static" # "-static-libgcc -static-libstdc++" "-all-static"
export MAKEFLAGS=-j$(nproc)

./scripts/001-kernel.sh
./scripts/002-initramfs.sh
./scripts/004-busybox.sh
./scripts/005-syslinux.sh
./scripts/006-memtest86.sh
# ./scripts/007-microwindows.sh
./scripts/008-dropbear.sh
./scripts/010-curl.sh
./scripts/011-nano.sh

./scripts/099-make.sh
./scripts/099-autoconf.sh
./scripts/099-automake.sh
./scripts/099-gmp-mpc-mpfr.sh
# ./scripts/099-binutils.sh
./scripts/099-gcc.sh

./scripts/012-initramfs.sh
./scripts/013-mkisofs.sh
./scripts/014-mk-boot-img.sh
