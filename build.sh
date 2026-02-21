#!/bin/bash
set -exuo pipefail

# debug mode drops into a shell inside the container instead of running the build scripts, 
# allowing you to inspect the container's filesystem and run commands manually
INTERACTIVE_MODE="-t --entrypoint /bin/bash"
DEBUG_MODE_1=""
if [ "${1:-}" = "-d1" ]; then
	DEBUG_MODE_1=$INTERACTIVE_MODE
fi
DEBUG_MODE_2=""
if [ "${1:-}" = "-d2" ]; then
	DEBUG_MODE_2=$INTERACTIVE_MODE
fi

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
