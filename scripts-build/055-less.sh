#!/usr/bin/bash
set -exuo pipefail

cd ./src/less

# The git tree ships no generated configure; Makefile.aut builds it.
if [ ! -x ./configure ]; then
	make -f Makefile.aut
fi

# less links ncurses for termcap. Pass-2 ncurses (--with-termlib) keeps the
# termcap symbols in libtinfow, which less's configure search list misses, so
# pre-seed LIBS (mirrors nano). Pass-1 debian needs no hint.
LESS_LIBS=
if ldconfig -p 2>/dev/null | grep -q 'libtinfow\.so'; then
	LESS_LIBS="-ltinfow"
fi

LIBS="$LESS_LIBS" ./configure --prefix=/usr --sysconfdir=/etc

make
make install DESTDIR=$INITRAMFS_DIR
