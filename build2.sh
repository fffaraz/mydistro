#!/bin/bash
set -exuo pipefail

rm -rf ./output
mkdir ./output
docker rm -f mydistro2

# docker pull debian:sid-slim
docker build -t mydistro2 -f ./Dockerfile2 .

docker run --privileged --rm -it \
	-v $(pwd)/src:/opt/mydistro/src \
	-v $(pwd)/scripts:/opt/mydistro/scripts \
	-v $(pwd)/output:/output \
	mydistro2
