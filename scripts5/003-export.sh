#!/bin/bash
set -exuo pipefail

rm -f ./output/stage6.tar.gz
tar \
	--exclude=/.dockerenv \
	--exclude=/dev \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/opt/mydistro \
	-czf ./output/stage6.tar.gz /
