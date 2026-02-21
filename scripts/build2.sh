#!/bin/bash
set -exuo pipefail

docker rm -f mydistro || true

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
