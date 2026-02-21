#!/bin/bash
set -exuo pipefail

ENTRY_POINT="--entrypoint /opt/mydistro/scripts/000-build.sh"
if [ "${1:-}" = "-d" ]; then
	ENTRY_POINT="-t --entrypoint /bin/bash"
fi

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
	$ENTRY_POINT \
	mydistro-builder:latest 2>&1 | tee ./output/build1.log

ls -alh ./output
