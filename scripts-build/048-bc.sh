#!/usr/bin/bash
set -exuo pipefail

cd ./src/bc

# Gavin Howard's bc ships a hand-written configure.sh, not autotools.
#   -G  skip generated tests (they need a pre-existing bc to diff against)
#   -O3 its own optimization level (CFLAGS' -O3 alone is ignored by configure.sh)
#   -M  don't install man pages — nothing in the initramfs reads them
#   -N  no NLS; locales ignore --prefix and would escape the DESTDIR otherwise
#
# -std=gnu17: gcc 15 defaults to C23, where `true`/`false` are keywords rather
# than macros expanding to 1/0. bc's BC_PARSE_EXPR_ENTRY pastes those tokens
# through UINTMAX_C() (UINTMAX_C(false) -> the undeclared `falseUL`), which only
# works while they still expand to numbers — so build against a pre-C23 standard.
CC=gcc CFLAGS="$CFLAGS -std=gnu17" ./configure.sh --prefix=/usr -G -O3 -M -N

make
make install DESTDIR=$INITRAMFS_DIR
