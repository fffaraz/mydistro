# mydistro
simple linux distro from scratch

compiles linux kernel + busybox + syslinux + memtest86 directly from source repo

```
docker build -t mydistro .

docker run --privileged --rm -it -v $(pwd)/output:/output mydistro
cp mydistro.iso /output

qemu-system-x86_64 -cdrom ./output/mydistro.iso
```
