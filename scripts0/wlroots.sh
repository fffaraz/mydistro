#!/bin/bash
set -exuo pipefail

cd ./src/wlroots

meson setup build/
ninja -C build/
