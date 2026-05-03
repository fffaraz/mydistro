#!/bin/bash
set -exuo pipefail

ENTRY_POINT="--entrypoint /opt/mydistro/scripts/000-build.sh"
SKIP_IMPORT=false

while getopts "dn" opt; do
	case $opt in
	d) ENTRY_POINT="-t --entrypoint /bin/sh" ;;
	n) SKIP_IMPORT=true ;;
	esac
done
shift $((OPTIND - 1))

STAGE="${1:?stage number required (>=2)}"
if ! [[ "$STAGE" =~ ^[0-9]+$ ]] || [ "$STAGE" -lt 2 ]; then
	echo "error: stage number must be an integer >= 2 (got: $STAGE)" >&2
	exit 1
fi

SCRIPTS_DIR="scripts${STAGE}"
IMAGE_NAME="mydistro-stage${STAGE}:latest"
ROOTFS_TARBALL="./output/stage${STAGE}.tar.gz"

docker rm -f mydistro || true

if [ "$SKIP_IMPORT" = false ]; then
	docker rmi -f "$IMAGE_NAME" || true
	docker import "$ROOTFS_TARBALL" "$IMAGE_NAME"
fi

docker run --privileged --rm -i --network none --name mydistro \
	-v $(pwd)/assets:/opt/mydistro/assets:ro \
	-v $(pwd)/$SCRIPTS_DIR:/opt/mydistro/scripts:ro \
	-v $(pwd)/src-lfs:/opt/mydistro/src-ro:ro \
	-v $(pwd)/output:/opt/mydistro/output \
	--workdir /opt/mydistro \
	--tmpfs /tmp \
	$ENTRY_POINT \
	"$IMAGE_NAME" 2>&1 | tee ./output/build${STAGE}.log

ls -alh ./output
