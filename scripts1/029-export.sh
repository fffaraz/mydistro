#!/bin/bash
set -exuo pipefail

cd ./rootfs

tar -czvf ../output/bootstrap.tar.gz .
