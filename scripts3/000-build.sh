#!/bin/bash
set -exuo pipefail

cp -r --reflink=auto ./src-ro ./src

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export PATH=/usr/bin:/usr/sbin:/bin:/sbin
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

COMMON_FLAGS="-O3 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

./scripts/010-man-pages.sh
./scripts/011-iana-etc.sh
./scripts/012-glibc.sh
./scripts/013-zlib.sh
./scripts/014-bzip2.sh
./scripts/015-xz.sh
./scripts/016-lz4.sh
./scripts/017-zstd.sh
./scripts/018-file.sh
./scripts/019-readline.sh
./scripts/020-pcre2.sh
./scripts/021-m4.sh
./scripts/022-bc.sh
./scripts/023-flex.sh
./scripts/024-tcl.sh
./scripts/025-expect.sh
./scripts/026-dejagnu.sh
./scripts/027-pkgconf.sh
./scripts/028-binutils.sh
./scripts/029-gmp.sh
./scripts/030-mpfr.sh
./scripts/031-mpc.sh
./scripts/032-attr.sh
./scripts/033-acl.sh
./scripts/034-libcap.sh
./scripts/035-libxcrypt.sh
./scripts/036-shadow.sh
./scripts/037-gcc.sh
./scripts/038-ncurses.sh
./scripts/039-sed.sh
./scripts/040-psmisc.sh
./scripts/041-gettext.sh
./scripts/042-bison.sh
./scripts/043-grep.sh
./scripts/044-bash.sh
./scripts/045-libtool.sh
./scripts/046-gdbm.sh
./scripts/047-gperf.sh
./scripts/048-expat.sh
./scripts/049-inetutils.sh
./scripts/050-less.sh
./scripts/051-perl.sh
./scripts/052-xml-parser.sh
./scripts/053-intltool.sh
./scripts/054-autoconf.sh
./scripts/055-automake.sh
./scripts/056-openssl.sh
./scripts/057-libelf.sh
./scripts/058-libffi.sh
./scripts/059-sqlite.sh
./scripts/060-python.sh
./scripts/061-flit-core.sh
./scripts/062-packaging.sh
./scripts/063-wheel.sh
./scripts/064-setuptools.sh
./scripts/065-ninja.sh
./scripts/066-meson.sh
./scripts/067-kmod.sh
./scripts/068-coreutils.sh
./scripts/069-diffutils.sh
./scripts/070-gawk.sh
./scripts/071-findutils.sh
./scripts/072-groff.sh
./scripts/073-grub.sh
./scripts/074-gzip.sh
./scripts/075-iproute2.sh
./scripts/076-kbd.sh
./scripts/077-libpipeline.sh
./scripts/078-make.sh
./scripts/079-patch.sh
./scripts/080-tar.sh
./scripts/081-texinfo.sh
./scripts/082-vim.sh
./scripts/083-markupsafe.sh
./scripts/084-jinja2.sh
./scripts/085-systemd.sh
./scripts/086-dbus.sh
./scripts/087-man-db.sh
./scripts/088-procps-ng.sh
./scripts/089-util-linux.sh
./scripts/090-e2fsprogs.sh

./scripts/091-stripping.sh
./scripts/092-cleanup.sh

./scripts/093-network.sh
./scripts/094-clock.sh
./scripts/095-locale.sh
./scripts/096-inputrc.sh
./scripts/097-etcshells.sh
./scripts/098-systemd-custom.sh

./scripts/099-fstab.sh
./scripts/100-kernel.sh
./scripts/101-grub.sh
