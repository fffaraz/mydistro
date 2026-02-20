# mydistro

A minimal Linux distribution built entirely from git source repositories.

Compiles the Linux kernel, busybox, syslinux, and more inside a Docker container with no internet access.

This project is in early development and is not yet functional for general use.

# Philosophy and Principles

All source code must come from a git repo, no tarbals, no binaries
No package manager, no partial updates
No internet required for installation
No internet to build the entire os from downloaded source repos
Self hosted. Must be compiled by itself with no external dependencies
Only one desktop env is supported

- **Linux from Scratch**: Follow the LFS guidelines for building a Linux system from source code.
- **Minimalism**: Only include essential components to keep the distribution lightweight and simple.
- **Transparency**: Build everything from source code available in git repositories. Using git repositories instead of tarballs allows better source control and reproducibility.

## Build Prerequisites

- Docker
- QEMU with KVM support

## Quick start

```sh
./build.sh    # download sources and compile everything in Docker
./run.sh      # boot the ISO in QEMU
```

## Build output

All artifacts are written to `output/` directory:

| File | Description |
|------|-------------|
| `bzImage` | Compressed kernel image |
| `initramfs.cpio` | Root filesystem archive |
| `mydistro.iso` | Bootable ISO image |
| `boot.img` | Bootable FAT disk image |
