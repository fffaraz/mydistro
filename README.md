# mydistro

A minimal Linux distribution built entirely from source.

This project is in early development and is not yet functional for general use.

# Philosophy and Principles

- **Source Transparency**: All source code comes from upstream git repositories. No tarballs, no binaries.
- **Atomic builds**: No package manager and no partial updates. The entire system is built as one unit.
- **Offline by design**: No internet connection is required to install or build the OS once sources are downloaded.
- **Self-hosted**: The distribution must be compilable by itself with no external dependencies.

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
