#!/usr/bin/bash
set -exuo pipefail

cd ./src
tar xf vim-*.tar.*
mv vim-*/ vim
cd ./vim

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >>src/feature.h

./configure --prefix=/usr

make
make install

ln -sv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
	ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim92/doc /usr/share/doc/vim-9.2.0078

cp ../../assets/etc/vimrc /etc/vimrc

cd ..
rm -rf ./vim
