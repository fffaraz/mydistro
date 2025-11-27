#!/bin/bash
set -exuo pipefail

./scripts/0000-source.sh

rm -rf ./output
mkdir ./output
docker rm -f mydistro

# docker pull debian:sid-slim
docker build -t mydistro .

docker run --privileged --rm -i --network none \
	-e "TERM=xterm-256color" \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	mydistro

# -t --entrypoint /bin/bash \
