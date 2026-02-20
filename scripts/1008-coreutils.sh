#!/bin/bash
set -exuo pipefail

cd ./src/coreutils

cp -r --reflink=auto ../gnulib ./gnulib-repo

git config --global --add safe.directory $(pwd)

./bootstrap --skip-po --gnulib-srcdir=./gnulib-repo
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime \
            CFLAGS="-Wno-error=unterminated-string-initialization -Wno-error=cast-align -Wno-error=switch-enum -Wno-error=calloc-transposed-args -Wno-error=maybe-uninitialized -Wno-error=format-overflow"

make
make DESTDIR=$LFS install

mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8
