#!/usr/bin/bash
set -exuo pipefail

cd moby
make binary
cd ..

cd docker-cli
make binary
