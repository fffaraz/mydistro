#!/bin/bash
set -exuo pipefail

# download source repositories
cd ./src
git config --global advice.detachedHead false

[ -d ./acl ]           || git clone --depth 1 -b v2.3.2 https://git.savannah.nongnu.org/git/acl.git
[ -d ./attr ]          || git clone --depth 1 -b v2.5.2 https://git.savannah.nongnu.org/git/attr.git
[ -d ./autoconf ]      || git clone --depth 1 -b v2.72 git://git.sv.gnu.org/autoconf # http://git.sv.gnu.org/r/autoconf.git
[ -d ./automake ]      || git clone --depth 1 -b v1.18.1 https://git.savannah.gnu.org/git/automake.git
[ -d ./bash ]          || git clone --depth 1 -b bash-5.3 https://git.savannah.gnu.org/git/bash.git
[ -d ./bc ]            || git clone --depth 1 -b 7.0.3 https://github.com/gavinhoward/bc.git
[ -d ./binutils-gdb ]  || git clone --depth 1 -b binutils-2_45 git://sourceware.org/git/binutils-gdb.git
[ -d ./bison ]         || git clone --depth 1 -b v3.8.2 https://git.savannah.gnu.org/git/bison.git
[ -d ./busybox ]       || git clone --depth 1 -b 1_37_0 https://git.busybox.net/busybox # https://github.com/mirror/busybox.git
[ -d ./bzip2 ]         || git clone --depth 1 -b bzip2-1.0.8 https://sourceware.org/git/bzip2.git
[ -d ./coreutils ]     || git clone --depth 1 -b v9.7 git://git.sv.gnu.org/coreutils # https://github.com/coreutils/coreutils.git git://git.savannah.gnu.org/coreutils.git
[ -d ./curl ]          || git clone --depth 1 -b curl-8_18_0 https://github.com/curl/curl.git
[ -d ./dejagnu ]       || git clone --depth 1 -b dejagnu-1.6.3-release git://git.sv.gnu.org/dejagnu.git
[ -d ./diffutils ]     || git clone --depth 1 -b v3.12 https://git.savannah.gnu.org/git/diffutils.git
[ -d ./dropbear ]      || git clone --depth 1 -b master https://github.com/mkj/dropbear.git
[ -d ./e2fsprogs ]     || git clone --depth 1 -b v1.47.3 git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
[ -d ./elfutils ]      || git clone --depth 1 -b elfutils-0.193 git://sourceware.org/git/elfutils.git
[ -d ./file ]          || git clone --depth 1 -b FILE5_46 https://github.com/file/file.git
[ -d ./findutils ]     || git clone --depth 1 -b v4.10.0 https://git.savannah.gnu.org/git/findutils.git
[ -d ./flex ]          || git clone --depth 1 -b v2.6.4 https://github.com/westes/flex.git
[ -d ./flit ]          || git clone --depth 1 -b 3.12.0 https://github.com/pypa/flit
[ -d ./gawk ]          || git clone --depth 1 -b gawk-5.3.2 https://git.savannah.gnu.org/git/gawk.git
[ -d ./gcc ]           || git clone --depth 1 -b releases/gcc-15.2.0 https://gcc.gnu.org/git/gcc.git
[ -d ./gdbm ]          || git clone --depth 1 -b v1.26 git://git.gnu.org.ua/gdbm.git
[ -d ./gettext ]       || git clone --depth 1 -b v0.26 https://git.savannah.gnu.org/git/gettext.git
[ -d ./git ]           || git clone --depth 1 -b v2.53.0 https://github.com/git/git.git
[ -d ./glibc ]         || git clone --depth 1 -b glibc-2.42 git://sourceware.org/git/glibc.git
[ -d ./gnulib ]        || git clone --depth 1 -b stable-202401 git://git.git.savannah.gnu.org/gnulib.git # https://github.com/coreutils/gnulib.git https://git.savannah.gnu.org/git/gnulib.git git://git.sv.gnu.org/gnulib.git https://gitweb.git.savannah.gnu.org/gitweb/?p=gnulib.git
[ -d ./gperf ]         || git clone --depth 1 -b v3.3 https://git.savannah.gnu.org/git/gperf.git
[ -d ./grep ]          || git clone --depth 1 -b v3.12 https://git.savannah.gnu.org/git/grep.git
[ -d ./groff ]         || git clone --depth 1 -b 1.23.0 https://git.savannah.gnu.org/git/groff.git
[ -d ./grub ]          || git clone --depth 1 -b grub-2.12 https://git.savannah.gnu.org/git/grub.git # https://cgit.git.savannah.gnu.org/cgit/grub.git
[ -d ./gzip ]          || git clone --depth 1 -b v1.14 https://git.savannah.gnu.org/git/gzip.git # https://cgit.git.savannah.gnu.org/cgit/gzip.git
[ -d ./inetutils ]     || git clone --depth 1 -b v2.6 https://git.savannah.gnu.org/git/inetutils.git # https://cgit.git.savannah.gnu.org/cgit/inetutils.git
[ -d ./libexpat ]      || git clone --depth 1 -b R_2_7_1 https://github.com/libexpat/libexpat.git
[ -d ./linux ]         || git clone --depth 1 -b v6.18 https://github.com/torvalds/linux.git
[ -d ./m4 ]            || git clone --depth 1 -b v1.4.20 git://git.sv.gnu.org/m4 # http://git.savannah.gnu.org/r/m4.git https://gitweb.git.savannah.gnu.org/gitweb/?p=m4.git
[ -d ./make ]          || git clone --depth 1 -b 4.4.1 https://git.savannah.gnu.org/git/make.git # https://www.gnu.org/software/make/
[ -d ./memtest86plus ] || git clone --depth 1 -v v8.00 https://github.com/memtest86plus/memtest86plus.git
[ -d ./microwindows ]  || git clone --depth 1 -b master https://github.com/ghaerr/microwindows.git
[ -d ./mpc ]           || git clone --depth 1 -b 1.3.1 https://gitlab.inria.fr/mpc/mpc.git # https://www.multiprecision.org/
[ -d ./mpfr ]          || git clone --depth 1 -b 4.2.2 https://gitlab.inria.fr/mpfr/mpfr.git # git@gitlab.inria.fr:mpfr/mpfr.git https://www.mpfr.org/git.html
[ -d ./musl ]          || git clone --depth 1 -b v1.2.5 git://git.musl-libc.org/musl # https://git.musl-libc.org/cgit/musl
[ -d ./nano ]          || git clone --depth 1 -b master https://github.com/madnight/nano.git # https://git.savannah.gnu.org/git/nano.git
[ -d ./ncurses ]       || git clone --depth 1 -b v6_5_20250809 https://github.com/ThomasDickey/ncurses-snapshots.git ./ncurses # https://www.gnu.org/software/ncurses/ https://ncurses.scripts.mit.edu/?p=ncurses.git
[ -d ./patch ]         || git clone --depth 1 -b v2.8 https://git.savannah.gnu.org/git/patch.git # https://cgit.git.savannah.gnu.org/cgit/patch.git
[ -d ./sed ]           || git clone --depth 1 -b v4.9 git://git.sv.gnu.org/sed # https://cgit.git.savannah.gnu.org/cgit/sed.git
[ -d ./syslinux ]      || git clone --depth 1 -b debian/master https://salsa.debian.org/images-team/syslinux.git # git://repo.or.cz/syslinux.git
[ -d ./tar ]           || git clone --depth 1 -b v1.35 https://git.savannah.gnu.org/git/tar.git # https://cgit.git.savannah.gnu.org/cgit/tar.git
[ -d ./toybox ]        || git clone --depth 1 -b 0.8.13 https://github.com/landley/toybox.git
[ -d ./wlroots ]       || git clone --depth 1 -b 0.18.3 https://gitlab.freedesktop.org/wlroots/wlroots.git
[ -d ./xz ]            || git clone --depth 1 -b v5.8.1 https://github.com/tukaani-project/xz.git

# https://www.linuxfromscratch.org/lfs/view/stable/chapter03/packages.html
# https://www.linuxfromscratch.org/lfs/view/stable/chapter03/patches.html

# TODO: couldn't find git repositories for these, so download tarballs instead

if [ ! -d ./expect ]; then
	curl -L -o expect.tar.gz "https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz"
	echo "00fce8de158422f5ccd2666512329bd2  expect.tar.gz" | md5sum -c
	mkdir -p ./expect
	tar -xzf expect.tar.gz -C ./expect --strip-components=1
	rm expect.tar.gz
fi

if [ ! -d ./gmp ]; then
	curl -L -o gmp.tar.xz "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
	echo "956dc04e864001a9c22429f761f2c283  gmp.tar.xz" | md5sum -c
	mkdir -p ./gmp
	tar -xJf gmp.tar.xz -C ./gmp --strip-components=1
	rm gmp.tar.xz
fi

if [ ! -d ./iana-etc ]; then
	curl -L -o iana-etc.tar.gz "https://github.com/Mic92/iana-etc/releases/download/20250807/iana-etc-20250807.tar.gz"
	echo "de0a909103d4ff59d1424c5ec7ac9e4a  iana-etc.tar.gz" | md5sum -c
	mkdir -p ./iana-etc
	tar -xzf iana-etc.tar.gz -C ./iana-etc --strip-components=1
	rm iana-etc.tar.gz
fi
