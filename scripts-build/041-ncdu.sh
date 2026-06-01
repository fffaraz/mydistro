#!/usr/bin/bash
set -exuo pipefail

cd ./src/ncdu

# Building from a git checkout: regenerate the autotools build system.
autoreconf -i

# ncurses is configured --with-termlib, so cbreak/define_key/etc. live in
# libtinfow rather than libncursesw. The shared libncursesw.so does carry a
# NEEDED entry for libtinfow, but modern ld defaults to
# --no-copy-dt-needed-entries, so symbols referenced directly by ncdu's objects
# (e.g. cbreak in main.o) won't resolve through the indirect DSO — link tinfow
# explicitly when present (same dance as nano's 011-nano.sh).
NCDU_LIBS=
if ldconfig -p 2>/dev/null | grep -q 'libtinfow\.so'; then
	NCDU_LIBS="-ltinfow"
fi
LIBS="$NCDU_LIBS" ./configure --prefix=/usr --with-ncursesw --mandir=/tmp/ncdu-man

make
make install DESTDIR=$INITRAMFS_DIR
