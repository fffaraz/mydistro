#!/bin/bash
set -exuo pipefail

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

rm -f ./output/stage3.tar.gz
tar \
	--exclude=/opt/mydistro \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/dev \
	--exclude=/.dockerenv \
	-czf ./output/stage3.tar.gz /
