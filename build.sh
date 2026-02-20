#!/bin/bash
set -exuo pipefail

# debug mode drops into a shell inside the container instead of running the build scripts, 
# allowing you to inspect the container's filesystem and run commands manually
DEBUG_MODE=""
if [ "${1:-}" = "-d" ]; then
	DEBUG_MODE="-t --entrypoint /bin/bash"
fi

# delete and recreate output directory
rm -rf ./output
mkdir ./output

# build the docker image for the build environment
# docker pull debian:sid-slim
docker rm -f mydistro-builder || true
docker build -t mydistro-builder .

# download source repositories on the host machine to avoid doing it inside the container, which doesn't have network access
./scripts/0000-source.sh

# run the build inside a docker container without network access
SECONDS=0
docker run --privileged --rm -i --network none --name mydistro-builder \
	-e "TERM=xterm-256color" \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	--tmpfs /tmp \
	$DEBUG_MODE \
	mydistro-builder 2>&1 | tee ./output/build.log
echo "docker run took $((SECONDS / 60))m $((SECONDS % 60))s"

docker rmi -f mydistro-initramfs:latest || true
[ -f ./output/initramfs.tar.gz ] && docker import ./output/initramfs.tar.gz mydistro-initramfs:latest
