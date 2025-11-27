#!/bin/bash
set -exuo pipefail

rm -rf ./output
mkdir ./output
docker rm -f mydistro

# docker pull debian:sid-slim
docker build -t mydistro .

./scripts/0000-source.sh

# --entrypoint /bin/bash \

docker run --privileged --rm -it --network none \
	-e "TERM=xterm-256color" \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/output \
	mydistro
