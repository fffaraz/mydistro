# mydistro

A minimal Linux distribution built entirely from source.

This project is in early development and is not yet functional for general use.

# Philosophy and Principles

- **Source transparency**: All source code comes from upstream git repositories. No tarballs, no binaries.
- **Atomic builds**: No package manager, no partial updates. The entire OS is built as one unit.
- **Offline by design**: No internet needed to install or build the OS once sources are downloaded.
- **Self-hosted**: The distribution can build itself with no external dependencies.
- **English/US-only**: Only English language and United States locale are supported.
- **Privacy-respecting**: No telemetry, no phoning home to update package repositories, no user age verification.

## Build Prerequisites

- Bash
- Git
- Curl
- Docker
- QEMU with KVM support (to run the built OS in a virtual machine)

## Quick start

```sh
./build.sh    # Download sources and compile everything in Docker
./run.sh      # Boot the ISO in a VM
```

## Build output

All artifacts are written to the `output/` directory:

| File | Description |
|------|-------------|
| `bzImage` | Compressed kernel image |
| `initramfs.cpio.gz` | Compressed root filesystem archive |
| `initramfs.tar.gz` | Compressed root filesystem archive in tar format |
| `mydistro.iso` | Bootable ISO image |
| `boot.img` | Bootable FAT disk image |
