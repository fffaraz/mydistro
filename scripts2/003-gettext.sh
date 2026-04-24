#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d gettext ]; then
	tar xf gettext-*.tar.*
	mv gettext-*/ gettext
	cd ./gettext
else
	cd ./gettext
	rmdir ./gnulib
	ln -s ../gnulib ./gnulib
	sed -i "s/am_set_or_augment = '+='/am_set_or_augment = '='/" ./gnulib/pygnulib/GLEmiter.py
	sed -i "s/am_set_or_augment='+='/am_set_or_augment='='/" ./gnulib/gnulib-tool.sh

	cat >./gettext-tools/tree-sitter.cfg <<"EOF"
TREE_SITTER_VERSION=0.23.2
TREE_SITTER_GO_VERSION=0.23.4
TREE_SITTER_RUST_VERSION=0.23.2
TREE_SITTER_TYPESCRIPT_VERSION=0.23.2
TREE_SITTER_D_VERSION=0.8.2
EOF

	./autogen.sh
fi

./configure --disable-shared
make

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
