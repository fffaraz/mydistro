#!/bin/bash
set -exuo pipefail

# debug mode drops into a shell inside the container instead of running the build scripts, allowing you to inspect the container's filesystem and run commands manually
DEBUG_MODE=""
if [ "${1:-}" = "-d" ]; then
	DEBUG_MODE="-t --entrypoint /bin/bash"
fi

# download source repositories
./scripts/0000-source.sh

# delete and recreate output directory
rm -rf ./output
mkdir ./output
docker rm -f mydistro || true

# build the docker image for the build environment
# docker pull debian:sid-slim
docker build -t mydistro .

# run the build inside a docker container without network access
docker run --privileged --rm -i --network none --name mydistro \
	-e "TERM=xterm-256color" \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	$DEBUG_MODE \
	mydistro
