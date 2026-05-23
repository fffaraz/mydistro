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

./autogen.sh

./configure --prefix=/usr --disable-static

# gettext-tools/examples/ relies on autopull.sh fetching per-language .po
# files from the Translation Project for examples like hello-csharp and
# hello-java*. We build offline (--network none), so update-po fails on
# every missing language. Drop the examples subdir — they're samples, not
# part of the runtime.
sed -i '/^SUBDIRS = /s/ examples//' gettext-tools/Makefile

make
make install DESTDIR=$INITRAMFS_DIR
