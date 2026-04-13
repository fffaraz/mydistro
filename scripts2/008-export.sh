#!/bin/bash
set -exuo pipefail

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

rm -f /opt/mydistro/output/stage3.tar.gz
tar --exclude=/opt/mydistro --exclude=/proc --exclude=/sys --exclude=/dev -czf /opt/mydistro/output/stage3.tar.gz /
