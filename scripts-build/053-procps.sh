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

# --disable-kill: util-linux (023) already installs `kill`; skip procps' copy to
#   avoid the file collision in $INITRAMFS_DIR.
# top, watch, slabtop and w link ncurses (099-ncurses provides the widec libs).
./configure \
	--prefix=/usr \
	--disable-static \
	--disable-kill

make
make install DESTDIR=$INITRAMFS_DIR
