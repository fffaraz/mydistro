#!/bin/bash
set -exuo pipefail

cd ./src
tar xf ninja-*.tar.*
mv ninja-*/ ninja
cd ./ninja

python3 configure.py --bootstrap --verbose

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

cd ..
rm -rf ./ninja
