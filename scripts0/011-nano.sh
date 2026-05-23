#!/bin/bash
set -exuo pipefail

cd ./src/nano

# Pass-1 texinfo XS modules were compiled against debian's perl, but pass-2
# perl differs — skip XS so texi2any falls back to pure Perl.
export TEXINFO_XS=omit

cp -r --reflink=auto ../gnulib ./gnulib

./autogen.sh
# Pass-2 ncurses is configured with --with-termlib, so define_key/tigetstr/etc.
# live in libtinfow rather than libncursesw — link it explicitly when present.
# Pass-1 (debian) has no libtinfow, and forcing it makes autoconf's compiler
# sanity check fail with "C compiler cannot create executables".
NANO_LIBS=
if ldconfig -p 2>/dev/null | grep -q 'libtinfow\.so'; then
	NANO_LIBS="-ltinfow"
fi
LIBS="$NANO_LIBS" ./configure --prefix=/usr --enable-utf8 --enable-year2038 --disable-nls --docdir=/tmp/nano-doc --mandir=/tmp/nano-man --infodir=/tmp/nano-info

make
make install DESTDIR=$INITRAMFS_DIR

# install terminfo entries so ncurses can initialize the terminal
mkdir -p $INITRAMFS_DIR/usr/share/terminfo/x
mkdir -p $INITRAMFS_DIR/usr/share/terminfo/l
cp /usr/share/terminfo/x/xterm-256color $INITRAMFS_DIR/usr/share/terminfo/x/
cp /usr/share/terminfo/x/xterm $INITRAMFS_DIR/usr/share/terminfo/x/
cp /usr/share/terminfo/l/linux $INITRAMFS_DIR/usr/share/terminfo/l/
