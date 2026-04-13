#!/bin/bash
set -exuo pipefail

if [ "${1:-}" = "--lfs" ]; then
	export BUILD_LFS=1
else
	export BUILD_LFS=0
fi

# download source repositories on the host machine to avoid doing it inside the container, which doesn't have network access
if [ "$BUILD_LFS" = "1" ]; then
	# ./scripts/download-src.sh ./deps/sources-lfs.conf
	./scripts/download-src-lfs.sh
else
	./scripts/download-src.sh ./deps/sources-min.conf
fi

# delete and recreate output directory
rm -rf ./output
mkdir ./output

SECONDS=0

if [ "$BUILD_LFS" = "1" ]; then
	# build the first stage of the build process, which creates a bootstrap image containing the compiled toolchain and initramfs
	./scripts/build1.sh

	# build the second stage of the build process, which creates the final image containing the compiled kernel and root filesystem
	./scripts/build2.sh
else
	./scripts/build0.sh
fi

echo "Build took $((SECONDS / 60))m $((SECONDS % 60))s"
