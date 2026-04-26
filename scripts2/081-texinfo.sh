#!/bin/bash
set -exuo pipefail

cd ./src
tar xf texinfo-*.tar.*
mv texinfo-*/ texinfo
cd ./texinfo

sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm

./configure --prefix=/usr

make
make check
make install

make TEXMF=/usr/share/texmf install-tex

pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd

cd ..
rm -rf ./texinfo
