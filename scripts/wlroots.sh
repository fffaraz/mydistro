#!/bin/bash

# compile wlroots

cd ./src/wlroots

meson setup build/
ninja -C build/
