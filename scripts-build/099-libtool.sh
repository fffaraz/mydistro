#!/usr/bin/bash
set -exuo pipefail

cd ./src/libtool

./bootstrap

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR

# libtool generates the "# serial N" line of m4/ltversion.m4 from `git log`.
# This offline, shallow-clone build has no git, so the serial comes out empty
# ("# serial  ltversion.m4"), which breaks `aclocal -Wall,error` in dependents
# such as 028-libxcrypt during pass 2. Rewrite the installed macro with a valid
# numeric serial (idempotent: a well-formed serial line won't match).
sed -i -E 's|^# serial[[:space:]]+ltversion\.m4|# serial 1 ltversion.m4|' \
	"$INITRAMFS_DIR/usr/share/aclocal/ltversion.m4"
