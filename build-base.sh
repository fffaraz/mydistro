#!/bin/bash
set -exuo pipefail

rm -rf ./output
mkdir ./output
docker rm -f mydistro-base

# docker pull debian:sid-slim
docker build -t mydistro-base -f ./Dockerfile.base .

# ./scripts/0002-source.sh

docker run --privileged --rm -it --network none \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/output \
	mydistro-base
