#!/bin/bash
set -exuo pipefail

cd ./rootfs

# fix symlink targets
rm ./sbin
rm ./usr/bin
rm ./usr/sbin
rm ./usr/local/bin
rm ./usr/local/sbin
rm ./usr/lib
rm ./usr/local/lib
ln -s /bin ./sbin
ln -s /bin ./usr/bin
ln -s /bin ./usr/sbin
ln -s /bin ./usr/local/bin
ln -s /bin ./usr/local/sbin
ln -s /lib ./usr/lib
ln -s /lib ./usr/local/lib

tar -czvf ../output/bootstrap.tar.gz .
