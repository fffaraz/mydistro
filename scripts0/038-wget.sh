#!/bin/bash
set -exuo pipefail

cd ./src/wget

# Stub out AX_CODE_COVERAGE (from autoconf-archive, which we don't ship).
# aclocal will pick this up via -I m4 and expand the macro to nothing.
cat >m4/ax_code_coverage.m4 <<'EOF'
AC_DEFUN([AX_CODE_COVERAGE], [])
EOF

# gnulib-tool unconditionally calls `wget` to fetch its own PO files from
# translationproject.org. The container has no network and no wget on the
# host image, and --skip-po only covers wget's own translations (not gnulib's).
# NLS is disabled below anyway, so feed gnulib-tool a no-op wget on PATH.
mkdir -p ./stub-bin
cat >./stub-bin/wget <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x ./stub-bin/wget
export PATH="$PWD/stub-bin:$PATH"

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--with-ssl=openssl \
	--disable-nls

# wget 1.25.0: gnulib_po/Makefile is generated with an empty top_builddir,
# turning $(top_builddir)/config.status into /config.status and breaking make.
# NLS is disabled, so drop the directory from SUBDIRS entirely.
sed -i 's| gnulib_po||' Makefile

make
make install DESTDIR=$INITRAMFS_DIR
