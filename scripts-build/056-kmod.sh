#!/usr/bin/bash
set -exuo pipefail

# kmod provides the kernel-module userland: insmod, rmmod, lsmod, modprobe,
# modinfo and depmod (all symlinks to the single `kmod` binary), plus libkmod.
# busybox supplied trimmed-down versions of these, but it is disabled, so
# nothing else in the build ships them.

cd ./src/kmod

# Building from a git checkout: autogen.sh runs autoreconf --force --install
# (gtkdocize is absent here, so it stubs out the gtk-doc macros) and then only
# prints suggested configure lines — it does NOT run configure itself, so we
# invoke configure below.
./autogen.sh

# kmod locates each compression/signature backend through pkg-config
# (PKG_CHECK_MODULES). zlib (zlib.pc, from debian's zlib1g-dev in pass 1) and
# openssl (libcrypto.pc, built by 003 into the container in both passes) are
# always present, so enable them unconditionally. zstd (libzstd) and xz
# (liblzma) only ship their .pc files in the pass-2 root (016/099-xz install
# into $INITRAMFS_DIR, and the debian base lacks the -dev packages), so probe
# for them and enable only when found — same pass-1/pass-2 asymmetry the less
# and procps scripts handle.
CONF=(--with-zlib --with-openssl)
for probe in libzstd:--with-zstd liblzma:--with-xz; do
	pc=${probe%%:*}
	flag=${probe#*:}
	if pkg-config --exists "$pc"; then
		CONF+=("$flag")
	fi
done

# --disable-manpages: the man pages are built with scdoc, which the OS does not
#   provide. --disable-static: ship only the shared libkmod, matching the rest
#   of the build.
./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--disable-manpages \
	"${CONF[@]}"

make
make install DESTDIR=$INITRAMFS_DIR
