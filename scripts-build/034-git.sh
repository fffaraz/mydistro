#!/usr/bin/bash
set -exuo pipefail

cd ./src/git

make configure
./configure \
	--prefix=/usr \
	--without-tcltk \
	--without-python

make NO_GETTEXT=1
make install NO_GETTEXT=1 DESTDIR=$INITRAMFS_DIR

# Also install git into the live build system (the base image has none) so the
# autotools packages rebuilt later in this pass (m4, autoconf, libtool, gettext,
# bison) can derive their version from `git describe`. Without git, their
# git-version-gen falls back to "UNKNOWN", which breaks downstream version
# checks (e.g. freetype's autogen.sh rejecting `libtoolize --version`) and
# leaves libtool's ltversion.m4 serial empty. safe.directory is required because
# the build runs as root over host-owned source trees ("dubious ownership").
make install NO_GETTEXT=1
git config --global --add safe.directory '*'
