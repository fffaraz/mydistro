#!/bin/bash

# download source repositories

# cd /opt/mydistro
mkdir -p ./src
cd ./src

git config --global advice.detachedHead false

git clone --depth 1 -b v6.16 https://github.com/torvalds/linux.git
git clone --depth 1 https://git.busybox.net/busybox
git clone --depth 1 https://salsa.debian.org/images-team/syslinux.git # git://repo.or.cz/syslinux.git
git clone --depth 1 https://github.com/memtest86plus/memtest86plus.git
git clone --depth 1 https://github.com/ghaerr/microwindows.git
git clone --depth 1 https://github.com/mkj/dropbear.git
git clone --depth 1 -b glibc-2.42 git://sourceware.org/git/glibc.git
git clone --depth 1 git://git.musl-libc.org/musl
git clone --depth 1 https://github.com/curl/curl.git

git clone --depth 1 https://github.com/madnight/nano.git # https://git.savannah.gnu.org/git/nano.git
git clone https://github.com/coreutils/gnulib.git ./nano/gnulib # git://git.sv.gnu.org/gnulib.git
