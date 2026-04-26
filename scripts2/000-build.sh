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

./scripts/001-fs.sh
./scripts/002-files.sh
./scripts/003-gettext.sh
./scripts/004-bison.sh
./scripts/005-perl.sh
./scripts/006-python.sh
./scripts/007-texinfo.sh
./scripts/008-util-linux.sh
./scripts/009-export1.sh

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
