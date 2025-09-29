#!/bin/bash

# compile memtest86+

cd /opt/mydistro/src/memtest86plus/build/x86_64
make -j$(nproc)
cp ./mt86plus /opt/mydistro/iso-dir/memtest
