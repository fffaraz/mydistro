#!/bin/bash
set -exuo pipefail

cd ./src/wget

# Stub out AX_CODE_COVERAGE (from autoconf-archive, which we don't ship).
# aclocal will pick this up via -I m4 and expand the macro to nothing.
cat >m4/ax_code_coverage.m4 <<'EOF'
AC_DEFUN([AX_CODE_COVERAGE], [])
EOF

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--with-ssl=openssl \
	--disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
