#!/bin/bash

# compile memtest86+
cd ./src/memtest86plus/build/x86_64

make -j$(nproc)
