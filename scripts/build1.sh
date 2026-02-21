#!/bin/bash
set -exuo pipefail

docker rm -f mydistro || true

# docker pull debian:sid-slim
# docker rmi -f mydistro-builder:latest || true
docker build -t mydistro-builder:latest .

docker run --privileged --rm -i --network none --name mydistro \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts1:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	--tmpfs /tmp \
	$DEBUG_MODE_1 \
	mydistro-builder:latest 2>&1 | tee ./output/build-1.log
