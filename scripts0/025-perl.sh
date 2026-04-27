#!/bin/bash
set -exuo pipefail

cd ./src/perl

# Configure perl as a non-debug, optimised build.
sh Configure -des \
	-Dprefix=/usr \
	-Dvendorprefix=/usr \
	-Dprivlib=/usr/lib/perl5/core_perl \
	-Darchlib=/usr/lib/perl5/core_perl \
	-Dsitelib=/usr/lib/perl5/site_perl \
	-Dsitearch=/usr/lib/perl5/site_perl \
	-Dvendorlib=/usr/lib/perl5/vendor_perl \
	-Dvendorarch=/usr/lib/perl5/vendor_perl \
	-Dman1dir=/tmp/perl-man1 \
	-Dman3dir=/tmp/perl-man3 \
	-Dpager="/usr/bin/less -isR" \
	-Duseshrplib \
	-Dusethreads

make
make install DESTDIR=$INITRAMFS_DIR
