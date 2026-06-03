#!/usr/bin/bash
set -exuo pipefail

cd ./src/readline

# readline's termcap backend lives in ncurses. Pass-2 ncurses is built
# --with-termlib, so the termcap symbols are in libtinfow rather than
# libncursesw; link that explicitly when present (mirrors nano). Pass-1
# (debian) has no libtinfow, so fall back to libncursesw.
RL_LIBS="-lncursesw"
if ldconfig -p 2>/dev/null | grep -q 'libtinfow\.so'; then
	RL_LIBS="-ltinfow"
fi

./configure --prefix=/usr --disable-static --with-curses

make SHLIB_LIBS="$RL_LIBS"
make install DESTDIR=$INITRAMFS_DIR
