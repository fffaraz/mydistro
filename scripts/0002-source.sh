#!/bin/bash

# download source repositories

# cd /opt/mydistro
mkdir -p ./src
cd ./src

git config --global advice.detachedHead false

[ -d ./linux ] || git clone --depth 1 -b v6.16 https://github.com/torvalds/linux.git
[ -d ./busybox ] || git clone --depth 1 https://git.busybox.net/busybox # https://github.com/mirror/busybox.git
[ -d ./syslinux ] || git clone --depth 1 https://salsa.debian.org/images-team/syslinux.git # git://repo.or.cz/syslinux.git
[ -d ./memtest86plus ] || git clone --depth 1 https://github.com/memtest86plus/memtest86plus.git
[ -d ./microwindows ] || git clone --depth 1 https://github.com/ghaerr/microwindows.git
[ -d ./dropbear ] || git clone --depth 1 https://github.com/mkj/dropbear.git
[ -d ./glibc ] || git clone --depth 1 -b glibc-2.42 git://sourceware.org/git/glibc.git
[ -d ./musl ] || git clone --depth 1 git://git.musl-libc.org/musl
[ -d ./curl ] || git clone --depth 1 https://github.com/curl/curl.git
[ -d ./toybox ] || git clone --depth 1 https://github.com/landley/toybox.git
[ -d ./coreutils ] || git clone --depth 1 https://github.com/coreutils/coreutils.git # git://git.savannah.gnu.org/coreutils.git

[ -d ./nano ] || git clone --depth 1 https://github.com/madnight/nano.git # https://git.savannah.gnu.org/git/nano.git
[ -d ./nano/gnulib ] || git clone https://github.com/coreutils/gnulib.git ./nano/gnulib # git://git.sv.gnu.org/gnulib.git

# [ -d ./ncurses ] || git clone --depth 1 https://github.com/mirror/ncurses
