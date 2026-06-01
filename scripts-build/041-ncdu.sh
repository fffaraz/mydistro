#!/usr/bin/bash
set -exuo pipefail

cd ./src/ncdu

# Building from a git checkout: regenerate the autotools build system.
autoreconf -i

# ncdu finds the wide-char ncurses through pkg-config (ncursesw.pc); ncurses
# was configured --with-termlib, so the shared libncursesw.so already pulls in
# libtinfow transitively — no extra LIBS wrangling needed here (unlike nano,
# whose configure does a raw link test).
./configure --prefix=/usr --with-ncursesw --mandir=/tmp/ncdu-man

make
make install DESTDIR=$INITRAMFS_DIR
