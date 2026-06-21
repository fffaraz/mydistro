#!/usr/bin/bash
set -exuo pipefail

cd ./src/libtool

./bootstrap

# libtool derives the "# serial N" line of m4/ltversion.m4 from `git log`
# (written to .serial). This offline, shallow-clone build has no git on the
# live system during pass 1, so the serial comes out empty
# ("# serial  ltversion.m4") and later trips `aclocal -Wall,error` in
# dependents such as 028-libxcrypt during pass 2. Seed a valid numeric serial;
# when git is available the generated rule overwrites it with the real count.
echo 1 >.serial

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
