# mydistro
simple linux distro from scratch

```
docker build -t mydistro .
docker run --privileged --rm -it -v $(pwd)/output:/output mydistro
cp mydistro.iso /output
qemu-system-x86_64 -cdrom ./output/mydistro.iso
```
