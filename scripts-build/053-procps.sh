#!/usr/bin/bash
set -exuo pipefail

# procps-ng provides the classic /proc-inspecting process tools: ps, top, free,
# uptime, vmstat, w, watch, pgrep/pkill, pmap, slabtop, sysctl, tload, pwdx.
# busybox supplied trimmed-down versions of several of these, but it is disabled,
# so nothing else in the build ships them.

cd ./src/procps

# Building from a git checkout: regenerate the autotools build system (also runs
# gettextize/autopoint for the po/ tree).
./autogen.sh

# procps locates ncurses *only* through pkg-config (PKG_CHECK_MODULES([ncursesw]);
# its AC_CHECK_LIB fallback is commented out upstream). 099-ncurses installs the
# widec libs into the container but without .pc files (no --enable-pc-files), so
# the probe fails. Pre-set NCURSES_CFLAGS/NCURSES_LIBS to non-empty values:
# PKG_CHECK_MODULES then skips pkg-config and trusts these instead. The headers
# (curses.h/ncurses.h/term.h) sit in the default /usr/include. 099 builds with
# --with-termlib, so top's <term.h> calls (setupterm/tigetstr) resolve from
# libtinfow rather than libncursesw — link both.
export NCURSES_CFLAGS="-I/usr/include"
export NCURSES_LIBS="-lncursesw -ltinfow"

# --disable-kill: util-linux (023) already installs `kill`; skip procps' copy to
#   avoid the file collision in $INITRAMFS_DIR.
./configure \
	--prefix=/usr \
	--disable-static \
	--disable-kill

make
make install DESTDIR=$INITRAMFS_DIR
