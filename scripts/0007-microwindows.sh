#!/bin/bash

# compile microwindows

cd ./src/microwindows/src
cp Configs/config.linux-fb config

sed -i 's/NX11                     = N/NX11 = Y/' config
sed -i 's/^X11_INCLUDE=\$(X11HDRLOCATION)/#&/; s/^#X11_INCLUDE=.\/X11-local/X11_INCLUDE=.\/X11-local/' nx11/Makefile

make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
