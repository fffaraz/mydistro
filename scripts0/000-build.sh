#!/bin/bash
set -exuo pipefail

mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

COMMON_FLAGS="-O3 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"
export MAKEFLAGS=-j$(nproc)
export SOURCE_DATE_EPOCH=1700000000 # fixed timestamp for reproducibility; 2023-11-14T22:13:20Z

export INITRAMFS_DIR=$(pwd)/initramfs-dir

command -v git >/dev/null 2>&1 && git config --global --add safe.directory '*'

# Offline build: gnulib-based ./bootstrap scripts call wget to fetch translation
# PO files. The container runs with --network none, so even a real wget would
# fail. Provide a no-op wget so bootstrap's "have wget?" check passes and the
# PO fetch silently succeeds (NLS is disabled in every package we build).
mkdir -p /tmp/stub-bin
cat >/tmp/stub-bin/wget <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x /tmp/stub-bin/wget
export PATH="/tmp/stub-bin:$PATH"

# Pass-1 texinfo XS modules were compiled against debian's perl, but pass-2
# perl differs — skip XS so texi2any falls back to pure Perl.
export TEXINFO_XS=omit

./scripts/001-kernel.sh
./scripts/002-initramfs.sh
./scripts/030-nasm.sh
./scripts/005-syslinux.sh
./scripts/006-memtest86.sh
# ./scripts/007-microwindows.sh
./scripts/008-dropbear.sh
./scripts/003-openssl.sh
./scripts/010-curl.sh
./scripts/032-pkgconf.sh
./scripts/011-nano.sh
./scripts/015-zstd.sh
./scripts/016-zlib.sh
./scripts/017-elfutils.sh

./scripts/018-bzip2.sh
./scripts/019-attr.sh
./scripts/020-acl.sh
./scripts/021-libexpat.sh
./scripts/031-python.sh
./scripts/022-iana-etc.sh
./scripts/023-util-linux.sh
./scripts/024-e2fsprogs.sh
./scripts/028-libxcrypt.sh
./scripts/025-perl.sh
./scripts/033-help2man.sh
./scripts/026-inetutils.sh
./scripts/027-gmp-mpc-mpfr.sh
./scripts/029-rsync.sh
./scripts/034-git.sh
./scripts/038-wget.sh

./scripts/009-glibc.sh
./scripts/099-make.sh
./scripts/099-gperf.sh
./scripts/099-m4.sh
./scripts/099-autoconf.sh
./scripts/099-automake.sh
./scripts/099-libtool.sh
./scripts/099-flex.sh
./scripts/099-bison.sh
./scripts/099-binutils.sh
./scripts/099-gcc.sh
./scripts/099-ncurses.sh
./scripts/099-bash.sh

./scripts/099-coreutils.sh
./scripts/099-diffutils.sh
./scripts/099-file.sh
./scripts/099-findutils.sh
./scripts/099-gawk.sh
./scripts/099-grep.sh
./scripts/099-gzip.sh
./scripts/099-patch.sh
./scripts/099-sed.sh
./scripts/099-tar.sh
./scripts/099-xz.sh

./scripts/099-gettext.sh
./scripts/099-texinfo.sh
./scripts/099-groff.sh

./scripts/004-busybox.sh
./scripts/012-initramfs.sh
./scripts/035-xorriso.sh
./scripts/013-mkisofs.sh
# ./scripts/036-mtools.sh
# ./scripts/037-dosfstools.sh
./scripts/014-mk-boot-img.sh
