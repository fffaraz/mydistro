#!/bin/bash
set -exuo pipefail

ENTRY_POINT="--entrypoint /opt/mydistro/scripts/000-build.sh"
SKIP_IMPORT=false

while getopts "dn" opt; do
	case $opt in
		d) ENTRY_POINT="-t --entrypoint /bin/bash" ;;
		n) SKIP_IMPORT=true ;;
	esac
done

docker rm -f mydistro || true

if [ "$SKIP_IMPORT" = false ]; then
	docker rmi -f mydistro-bootstrap:latest || true
	docker import ./output/bootstrap.tar.gz mydistro-bootstrap:latest
fi

docker run --privileged --rm -i --network none --name mydistro \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/scripts2:/opt/mydistro/scripts:ro \
	-v $(pwd)/src:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	--tmpfs /tmp \
	$ENTRY_POINT \
	mydistro-bootstrap:latest 2>&1 | tee ./output/build2.log

ls -alh ./output
