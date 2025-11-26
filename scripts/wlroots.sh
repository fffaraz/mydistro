#!/bin/bash

# compile wlroots

cd /opt/mydistro/src/wlroots

meson setup build/
ninja -C build/
