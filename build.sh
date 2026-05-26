#!/bin/bash
set -exuo pipefail

if [ "${1:-}" = "--lfs" ]; then
	export BUILD_LFS=1
else
	export BUILD_LFS=0
fi

# download source repositories on the host machine to avoid doing it inside the container, which doesn't have network access
if [ "$BUILD_LFS" = "1" ]; then
	./scripts-host/download-src-lfs.sh
else
	./scripts-host/download-src.sh ./deps/sources.conf
fi

# ensure output directory exists and clear its contents
mkdir -p ./output
rm -rf ./output/*
mkdir -p ./output/{1,2,lfs}

SECONDS=0

if [ "$BUILD_LFS" = "1" ]; then
	./scripts-host/build-lfs1.sh   # first stage
	./scripts-host/build-lfs2.sh 2 # second stage
	./scripts-host/build-lfs2.sh 3 # third stage
	./scripts-host/build-lfs2.sh 4 # fourth stage
	./scripts-host/build-lfs2.sh 5 # fifth stage
else
	./scripts-host/build-pass1.sh # first pass
	./scripts-host/build-pass2.sh # second pass
fi

echo "Build took $((SECONDS / 60))m $((SECONDS % 60))s"
