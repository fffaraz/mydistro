# mydistro

A minimal Linux distribution built entirely from source. Compiles the Linux kernel, busybox, syslinux, and more inside a Docker container with no internet access.

## Prerequisites

- Docker
- QEMU with KVM support

## Quick start

```sh
./build.sh    # download sources and compile everything in Docker
./run.sh      # boot the ISO in QEMU
```

## Build output

All artifacts are written to `output/`:

| File | Description |
|------|-------------|
| `bzImage` | Compressed kernel image |
| `initramfs.cpio` | Root filesystem archive |
| `mydistro.iso` | Bootable ISO image |
| `boot.img` | Bootable FAT disk image |
