# mydistro

A minimal Linux distribution built entirely from source, inside Docker.

This project is in early development and is not yet functional for general use.

> **Note**: We are looking for a better name to use for this distro. Suggestions welcome.

## Philosophy and Principles

- **Source transparency**: All source code comes from upstream git repositories. No tarballs, no binaries.
- **Atomic builds**: No package manager, no partial updates. The entire OS is built as one unit.
- **Offline by design**: No internet needed to install or build the OS once sources are downloaded.
- **Privacy-respecting**: No telemetry, no phoning home to update package repositories, no user age verification.
- **Optimized builds**: Compiled with `-O3 -march=native` for maximum performance on the build host's CPU.
- **Self-hosted**: The distribution can build itself with no external dependencies.
- **English/US-only**: Only English language and United States locale are supported.

## Build Prerequisites

- Bash
- Git
- Curl
- Docker
- QEMU with KVM support (to run the built OS in a virtual machine)

## Quick start

```sh
./build.sh           # Main mode: build from upstream git sources
./build.sh --lfs     # LFS mode: build following the Linux From Scratch book
./run.sh --qemu      # Boot the ISO in QEMU (graphical)
./run.sh --cli       # Boot the kernel + initramfs on a serial console
./run.sh --docker    # Run the initramfs as a Docker container
```

Sources are downloaded on the host first, then every build step runs offline inside a privileged container with `--network none`.

## Build output

All artifacts are written to the `output/` directory:

| File | Description |
|------|-------------|
| `bzImage` | Compressed kernel image |
| `initramfs.cpio.gz` | Compressed root filesystem archive |
| `initramfs.tar.gz` | Root filesystem archive in tar format |
| `mydistro.iso` | Bootable ISO image |
| `boot.img` | Bootable FAT disk image |
