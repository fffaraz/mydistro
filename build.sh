#!/bin/bash
set -exuo pipefail

# download source repositories on the host machine to avoid doing it inside the container, which doesn't have network access
./scripts/source.sh

# delete and recreate output directory
rm -rf ./output
mkdir ./output

SECONDS=0

# build the first stage of the build process, which creates a bootstrap image containing the compiled toolchain and initramfs
./scripts/build1.sh

# build the second stage of the build process, which creates the final image containing the compiled kernel and root filesystem
./scripts/build2.sh

echo "build took $((SECONDS / 60))m $((SECONDS % 60))s"

docker rmi -f mydistro-initramfs:latest || true
[ -f ./output/initramfs.tar.gz ] && docker import ./output/initramfs.tar.gz mydistro-initramfs:latest
