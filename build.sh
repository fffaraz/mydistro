#!/bin/bash
set -exuo pipefail

if [ "${1:-}" = "--lfs" ]; then
	export BUILD_LFS=1
else
	export BUILD_LFS=0
fi

# download source repositories on the host machine to avoid doing it inside the container, which doesn't have network access
if [ "$BUILD_LFS" = "1" ]; then
	./scripts/download-src-lfs.sh
else
	./scripts/download-src.sh ./deps/sources.conf
fi

# delete and recreate output directory
rm -rf ./output
mkdir ./output

SECONDS=0

if [ "$BUILD_LFS" = "1" ]; then
	./scripts/build-lfs-1.sh # first stage
	./scripts/build-lfs-2.sh # second stage
else
	./scripts/build1.sh # first pass
	./scripts/build2.sh # second pass
fi

echo "Build took $((SECONDS / 60))m $((SECONDS % 60))s"
