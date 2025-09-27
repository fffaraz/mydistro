#!/bin/bash
set -exuo pipefail

rm -rf ./output
docker rm -f mydistro

mkdir ./output

# docker pull debian:sid-slim
docker build -t mydistro .

# docker run --privileged --rm -it -v $(pwd)/output:/output mydistro
# cp mydistro.iso /output

docker run --privileged -d -it --name mydistro mydistro
docker cp mydistro:/opt/mydistro/src/linux/arch/x86/boot/bzImage $(pwd)/output/bzImage
docker cp mydistro:/opt/mydistro/myiso/initramfs $(pwd)/output/initramfs.cpio
docker cp mydistro:/opt/mydistro/mydistro.iso $(pwd)/output/mydistro.iso
docker exec -it mydistro /opt/mydistro/mk-boot-img.sh
docker cp mydistro:/opt/mydistro/boot.img $(pwd)/output/boot.img
docker rm -f mydistro
