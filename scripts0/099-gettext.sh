#!/bin/bash
set -exuo pipefail

cd ./src/gettext

# Versions match deps/sources.conf — these are what autopull.sh would clone.
TREE_SITTER_VERSION=0.23.2
TREE_SITTER_GO_VERSION=0.23.4
TREE_SITTER_RUST_VERSION=0.23.2
TREE_SITTER_TYPESCRIPT_VERSION=0.23.2
TREE_SITTER_D_VERSION=0.8.2

# Stage the tree-sitter sources into gettext-tools/ the way autopull.sh would.
# Copy into a scratch dir, apply the in-tree portability patch(es), then move
# the bits gettext expects into the versioned directory.
stage_ts() {
	# $1 = source dir name under ../  (e.g. tree-sitter-go)
	rm -rf _ts
	cp -r --reflink=auto "../$1" _ts
	# Drop the .git dir so patch -p1 does not try to touch it.
	rm -rf _ts/.git
}

if [ ! -d "gettext-tools/tree-sitter-$TREE_SITTER_VERSION" ]; then
	stage_ts tree-sitter
	(cd _ts && patch -p1) <gettext-tools/build-aux/tree-sitter-portability.diff
	d=gettext-tools/tree-sitter-$TREE_SITTER_VERSION
	mkdir "$d"
	mv _ts/LICENSE "$d/LICENSE"
	mv _ts/lib "$d/lib"
	rm -rf _ts
fi

if [ ! -d "gettext-tools/tree-sitter-go-$TREE_SITTER_GO_VERSION" ]; then
	stage_ts tree-sitter-go
	(cd _ts && patch -p1) <gettext-tools/build-aux/tree-sitter-go-portability.diff
	d=gettext-tools/tree-sitter-go-$TREE_SITTER_GO_VERSION
	mkdir "$d"
	mv _ts/LICENSE "$d/LICENSE"
	mv _ts/src "$d/src"
	mv "$d/src/parser.c" "$d/src/go-parser.c"
	rm -rf _ts
fi

if [ ! -d "gettext-tools/tree-sitter-rust-$TREE_SITTER_RUST_VERSION" ]; then
	stage_ts tree-sitter-rust
	(cd _ts && patch -p1) <gettext-tools/build-aux/tree-sitter-rust-portability.diff
	d=gettext-tools/tree-sitter-rust-$TREE_SITTER_RUST_VERSION
	mkdir "$d"
	mv _ts/LICENSE "$d/LICENSE"
	mv _ts/src "$d/src"
	mv "$d/src/parser.c" "$d/src/rust-parser.c"
	mv "$d/src/scanner.c" "$d/src/rust-scanner.c"
	rm -rf _ts
fi

if [ ! -d "gettext-tools/tree-sitter-typescript-$TREE_SITTER_TYPESCRIPT_VERSION" ]; then
	stage_ts tree-sitter-typescript
	(cd _ts && patch -p1) <gettext-tools/build-aux/tree-sitter-typescript-portability.diff
	d=gettext-tools/tree-sitter-typescript-$TREE_SITTER_TYPESCRIPT_VERSION
	mkdir -p "$d/common" "$d/typescript" "$d/tsx"
	mv _ts/LICENSE "$d/LICENSE"
	mv _ts/common/scanner.h "$d/common/scanner.h"
	mv _ts/typescript/src "$d/typescript/src"
	mv _ts/tsx/src "$d/tsx/src"
	mv "$d/typescript/src/parser.c" "$d/typescript/src/ts-parser.c"
	mv "$d/typescript/src/scanner.c" "$d/typescript/src/ts-scanner.c"
	mv "$d/tsx/src/parser.c" "$d/tsx/src/tsx-parser.c"
	mv "$d/tsx/src/scanner.c" "$d/tsx/src/tsx-scanner.c"
	rm -rf _ts
fi

if [ ! -d "gettext-tools/tree-sitter-d-$TREE_SITTER_D_VERSION" ]; then
	stage_ts tree-sitter-d
	(cd _ts && patch -p1) <gettext-tools/build-aux/tree-sitter-d-portability.diff
	(cd _ts && patch -p1) <gettext-tools/build-aux/tree-sitter-d-optimization-bug.diff
	d=gettext-tools/tree-sitter-d-$TREE_SITTER_D_VERSION
	mkdir "$d"
	mv _ts/LICENSE.txt "$d/LICENSE"
	mv _ts/src "$d/src"
	mv "$d/src/parser.c" "$d/src/d-parser.c"
	mv "$d/src/scanner.c" "$d/src/d-scanner.c"
	rm -rf _ts
fi

cat >gettext-tools/tree-sitter.cfg <<EOF
TREE_SITTER_VERSION=$TREE_SITTER_VERSION
TREE_SITTER_GO_VERSION=$TREE_SITTER_GO_VERSION
TREE_SITTER_RUST_VERSION=$TREE_SITTER_RUST_VERSION
TREE_SITTER_TYPESCRIPT_VERSION=$TREE_SITTER_TYPESCRIPT_VERSION
TREE_SITTER_D_VERSION=$TREE_SITTER_D_VERSION
EOF

# glibc 2.43's features.h forces _ISOC23_SOURCE=1 whenever _GNU_SOURCE is set
# (autoconf's AC_USE_SYSTEM_EXTENSIONS sets _GNU_SOURCE), which forces
# __GLIBC_USE_ISOC23=1 regardless of __STDC_VERSION__. <wchar.h> and <stdlib.h>
# then define wmemchr/bsearch as function-like _Generic macros. gnulib's
# "Declarations for ISO C N3322" block (guarded by __GNUC__ >= 15) redeclares
# those names as plain functions, and the macro expands inside the
# redeclaration, producing "expected identifier or '(' before '_Generic'".
# Pinning -std=gnu17 used to suppress this on glibc 2.41 but is bypassed by
# the _GNU_SOURCE chain on 2.43. Undef the names inside that block before
# they get redeclared. Patch the gnulib master before autogen.sh so the fix
# propagates through gnulib-tool into every gettext-*/gnulib-lib/ copy.
sed -i '/^#if defined __GNUC__ && __GNUC__ >= 15 && !defined __clang__$/a\
# undef wmemcpy\
# undef wmemmove\
# undef wcsncpy\
# undef wcsncat\
# undef wmemcmp\
# undef wcsncmp\
# undef wmemchr\
# undef wmemset' gnulib/lib/wchar.in.h
sed -i '/^#if defined __GNUC__ && __GNUC__ >= 15 && !defined __clang__$/a\
# undef bsearch\
# undef qsort' gnulib/lib/stdlib.in.h

export CFLAGS="${CFLAGS} -std=gnu17"
export CXXFLAGS="${CXXFLAGS} -std=gnu++17"


./autogen.sh

./configure --prefix=/usr --disable-static

# gettext-tools/examples/ relies on autopull.sh fetching per-language .po
# files from the Translation Project for examples like hello-csharp and
# hello-java*. We build offline (--network none), so update-po fails on
# every missing language. Drop the examples subdir — they're samples, not
# part of the runtime.
sed -i '/^SUBDIRS = /s/ examples//' gettext-tools/Makefile

make

# Pass 2's freshly-built initramfs has no groff, so gettext's HTML man pages
# don't get rendered and install-html-local then fails copying nonexistent
# files. The .1 man pages are also absent: they're regenerated from the just-
# built binaries via help2man, and the rule chain depends on $(top_srcdir)/
# ../.version (a gnulib bootstrap file) which doesn't exist in a from-git
# build. Touch empty stubs for $(man_HTML) and $(man_MANS) so the install
# step succeeds — rendered man pages aren't something an initramfs needs.
for d in gettext-runtime/man gettext-tools/man; do
	[ -f "$d/Makefile" ] || continue
	for var in man_HTML man_MANS; do
		for f in $(make -C "$d" -s --eval="_dump_${var}:; @echo \$(${var})" "_dump_${var}" 2>/dev/null); do
			[ -e "$d/$f" ] || : >"$d/$f"
		done
	done
done

make install DESTDIR=$INITRAMFS_DIR

# Inject a gettext-${ARCHIVE_VERSION}/ entry into the installed autopoint
# archive. Release tarballs ship this entry pre-baked; a from-git build
# leaves it absent because gettext-tools/misc/archive.dir.tar is not in
# version control — the Makefile bootstraps the archive from the host's
# already-installed gettext (debian's, in pass 1) and copies it through
# unchanged. Without this, pass 2's autoreconf of elfutils fails with
# "infrastructure files for version 0.26 not found".
#
# add-to-archive in the source does the same thing but expects a release
# tar.gz; we replicate the directory-assembly half against the install tree.
ARCHIVE_VERSION=$(sed -n 's/^ARCHIVE_VERSION=//p' gettext-tools/configure.ac)
ARCHIVE=$INITRAMFS_DIR/usr/share/gettext/archive.dir.tar.xz
PKGDATA=$INITRAMFS_DIR/usr/share/gettext

work=$(mktemp -d)
mkdir "$work/extracted"
xz -dc <"$ARCHIVE" | tar -xf - -C "$work/extracted"

dst=$work/extracted/gettext-$ARCHIVE_VERSION
rm -rf "$dst"
mkdir -p "$dst/po" "$dst/m4"
cp -p "$PKGDATA/ABOUT-NLS" "$dst/"
cp -p "$PKGDATA/config.rpath" "$dst/"
find "$PKGDATA/po" -maxdepth 1 -type f ! -name Makevars \
	-exec cp -p {} "$dst/po/" \;
cp -p "$PKGDATA/m4/"*.m4 "$dst/m4/"

(cd "$work/extracted" && tar -cf - --owner=0 --group=0 -- *) |
	xz -c >"$ARCHIVE.new"
mv "$ARCHIVE.new" "$ARCHIVE"
rm -rf "$work"
