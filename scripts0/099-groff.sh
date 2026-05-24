#!/bin/bash
set -exuo pipefail

cd ./src/groff

./bootstrap

PAGE=letter ./configure --prefix=/usr

# xpmtoppm (netpbm) isn't in the distro yet, so bypass the rule that
# regenerates this example doc image from doc/gnu.xpm. PSPIC rejects an
# empty file, so drop in a minimal valid EPS placeholder instead.
mkdir -p doc
cat >doc/gnu.eps <<'EOF'
%!PS-Adobe-3.0 EPSF-3.0
%%BoundingBox: 0 0 1 1
%%EndComments
%%Page: 1 1
showpage
%%EOF
EOF
touch -d '2099-01-01' doc/gnu.eps

make
make install DESTDIR=$INITRAMFS_DIR
