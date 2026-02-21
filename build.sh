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
./scripts/0000-source.sh

# delete and recreate output directory
rm -rf ./output
mkdir ./output
docker rm -f mydistro || true

# build the docker image for the build environment
# docker pull debian:sid-slim
# docker rmi -f mydistro-builder:latest || true
docker build -t mydistro-builder .

SECONDS=0

# run the build inside a docker container without network access
docker run --privileged --rm -i --network none --name mydistro \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts1:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	--tmpfs /tmp \
	$DEBUG_MODE_1 \
	mydistro-builder 2>&1 | tee ./output/build-1.log

exit 0

docker rmi -f mydistro-bootstrap:latest || true
docker import ./output/bootstrap.tar.gz mydistro-bootstrap:latest

docker run --privileged --rm -i --network none --name mydistro \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts2:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	--tmpfs /tmp \
	$DEBUG_MODE_2 \
	mydistro-bootstrap:latest 2>&1 | tee ./output/build-2.log

echo "build took $((SECONDS / 60))m $((SECONDS % 60))s"

docker rmi -f mydistro-initramfs:latest || true
[ -f ./output/initramfs.tar.gz ] && docker import ./output/initramfs.tar.gz mydistro-initramfs:latest
