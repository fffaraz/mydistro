# mydistro — AI agent context

A from-scratch Linux distribution built entirely from source inside Docker. There are **two completely independent build modes** that share nothing except the top-level `build.sh` dispatcher and the Debian-based `Dockerfile` used to bootstrap stage 1.

Always identify which mode the user's request targets before reading any script. `scripts0/` and `scripts1/`..`scripts6/` are unrelated codebases — do not cross-reference them.

## Mode A — "main" mode (`scripts0/`)

The primary mode. Builds the OS from upstream **git source repositories**, in a single pass repeated twice for self-hosting.

- **Sources**: `src/` (one subdir per dependency, cloned from upstream git). Listed in `deps/sources.conf`. Downloaded by `scripts/download-src.sh`.
- **Build scripts**: `scripts0/` only. The execution order is dictated by `scripts0/000-build.sh`, **not** by filename ordering. Optional scripts that `000-build.sh` does **not** call: `009-musl.sh` (alternate libc), `ladybird.sh`, `moby.sh`, `podman.sh`, `toybox.sh`, `wlroots.sh`. The `099-*` toolchain rebuilds (make, m4, autoconf, automake, flex, bison, binutils, gcc, ncurses, bash, coreutils, diffutils, file, findutils, gawk, gettext, gperf, grep, gzip, patch, sed, tar, xz) **are** wired in and rebuild themselves against the freshly built glibc — always check `000-build.sh` before assuming a script is live.
- **Pass 1** — `scripts/build1.sh`: runs `scripts0/` inside a container based on `debian:sid-slim` (the project `Dockerfile`). Produces `output/initramfs.tar.gz`.
- **Pass 2** — `scripts/build2.sh`: imports `initramfs.tar.gz` as the image `mydistro-initramfs:latest` and re-runs the **same `scripts0/`** inside it. This is the self-hosting step (the OS rebuilds itself).
- **Container mounts** (both passes):
  - `src/` → `/opt/mydistro/src-ro` **read-only**; `000-build.sh` then overlay-mounts a writable tmpfs at `./src`. **Build steps must `cd ./src/<pkg>`, never `./src-ro/<pkg>`.**
  - `scripts0/` → `/opt/mydistro/scripts` read-only.
  - `assets/` read-only, `output/` writable.

Invoke: `./build.sh` (add `-d` to `build1.sh`/`build2.sh` for an interactive shell; `build2.sh -n` skips the `docker import` step when iterating).

**`deps/sources.conf` format** (one entry per line, whitespace-separated, `#` comments allowed):
```
<dir_or_file>  git  <repo_url>      <branch_or_tag>
<filename>     url  <download_url>  <sha256:...|md5:...>
```
`git` entries are shallow clones (`--depth=1 --recurse-submodules`) into `src/<dir_name>`. `url` entries are downloaded into `src/<filename>` and hash-verified.

## Mode B — "LFS" mode (`scripts1/` + `scripts2/` + `scripts3/` + `scripts4/` + `scripts5/` [+ `scripts6/`])

Follows the **Linux From Scratch book**, with these deliberate departures from LFS:

- **No real chroot** — each LFS stage runs in its own Docker container instead.
- **Stage 1 container** is `debian:sid-slim` (same `Dockerfile` as Mode A). It builds an LFS cross-toolchain + temp tools into `output/stage2.tar.gz` instead of using a host toolchain + chroot.
- **Stages 2..N containers** are built by `docker import`-ing the previous stage's `output/stage${N}.tar.gz` as `mydistro-stage${N}:latest`, then continuing the LFS build inside it. This replaces LFS's `chroot $LFS` and is repeated per chapter group.
- **Sources are upstream tarballs** (the LFS-prescribed versions), not git — this is the opposite of Mode A.

Pipeline (driven by `build.sh --lfs`):

| Stage | Script dir | Container base | Reads | Writes | LFS book correspondence |
|------|------------|----------------|-------|--------|------------------------|
| 1 | `scripts1/` | `mydistro-builder` (debian:sid-slim) | `src-lfs/` | `stage2.tar.gz` (contents of `$LFS=./rootfs`) | ch. 5–6 (cross-toolchain + temp tools) |
| 2 | `scripts2/` | `mydistro-stage2` (from `stage2.tar.gz`) | `src-lfs/` | `stage3.tar.gz` (rootfs `/`) | ch. 7 (enter chroot, set up fs/files, install gettext, bison, perl, python, texinfo, util-linux) |
| 3 | `scripts3/` | `mydistro-stage3` | `src-lfs/` | `stage4.tar.gz` | ch. 8 (final system: glibc, binutils, gcc, all userland packages, ending with stripping + cleanup) |
| 4 | `scripts4/` | `mydistro-stage4` | only `linux-*.tar.*` from `src-lfs/` | `stage5.tar.gz` | ch. 10 (kernel build) |
| 5 | `scripts5/` | `mydistro-stage5` | `assets/` only | `bzImage`, `initramfs.cpio.gz` (+ `stage6.tar.gz`) | ch. 9 / 11 (system config files, GRUB config, final image export) |
| 6 | `scripts6/` | `mydistro-stage6` | — | — | **not invoked by `build.sh`** — placeholder (`000-build.sh` is empty), reserved for a future post-final stage |

`build.sh --lfs` runs stages 1–5 only. `scripts6/` exists but is not yet wired into the pipeline.

Layout details:
- **Sources**: `src-lfs/` (tarballs). Versions and checksums come straight from the LFS book — `deps/wget-list-systemd` (URLs) + `deps/md5sums` (md5s). Downloaded by `scripts/download-src-lfs.sh`.
- **Stage 1 (`scripts1/`)** uses an overlay mount on `./src` like Mode A.
- **Stages 2 and 3** use `cp -r --reflink=auto ./src-ro ./src` instead of an overlay mount (the imported pass-2+ images lack the kernel module / capabilities for overlayfs in some setups). Same end result — never write to `src-ro`.
- **Stage 4** only copies `linux-*.tar.*` out of `src-ro` (kernel is the only package it needs).
- **Stage 5** reads no source tarballs — it only consumes `./assets/` to drop config files into `/etc` and `/boot/grub/`.
- **Container mounts**: same pattern as Mode A but with `src-lfs/` → `/opt/mydistro/src-ro` read-only and `scripts${N}/` → `/opt/mydistro/scripts`.

Invoke: `./build.sh --lfs`.

- `scripts/build-lfs-1.sh [-d]`: runs stage 1 in `mydistro-builder`. `-d` drops to a shell.
- `scripts/build-lfs-2.sh [-d] [-n] <stage>`: runs stage `<stage>` (≥ 2). Imports `output/stage${stage}.tar.gz` as `mydistro-stage${stage}:latest`, mounts `scripts${stage}/`, logs to `output/build${stage}.log`. `-d` shell, `-n` skip `docker import` when iterating.

## Shared mechanics

- **Read-only source + writable workspace**: in every container, the host source dir is mounted read-only at `./src-ro`; `000-build.sh` exposes a writable copy at `./src`. Method depends on container capabilities — overlayfs on tmpfs in Mode A and B-stage-1; reflink copy in B-stages-2/3 (stage 4 only copies the kernel tarball; stage 5 doesn't touch `src-ro`). Builds can patch/configure freely without dirtying the host tree.
- **Offline builds**: containers run with `--network none` and `--privileged` (privileged is needed for the overlay mount). All downloads happen on the host before the container starts.
- **Compiler flags** (set by every `000-build.sh`): `CFLAGS`/`CXXFLAGS` = `-O3 -pipe -march=native -Wno-error`, `MAKEFLAGS=-j$(nproc)`. `-march=native` means built artifacts are tied to the build host's CPU.
- **Architecture**: x86_64 only (hardcoded throughout — kernel target, `qemu-system-x86_64`, `bzImage`, syslinux/grub-x86).
- **Output**: everything lands in `output/` (cleared at the start of each `./build.sh` run). Final artifacts: Mode A — `bzImage`, `initramfs.cpio.gz`, `initramfs.tar.gz`, `mydistro.iso`, `boot.img`; Mode B — `bzImage`, `initramfs.cpio.gz` (plus the intermediate `stage${N}.tar.gz` files each LFS stage leaves behind).
- **Run the result**: `./run.sh --cli` (serial console, uses `bzImage` + `initramfs.cpio.gz`), `--qemu` (graphical ISO boot — Mode A only, since Mode B doesn't build an ISO), or `--docker` (import the initramfs and run a shell — Mode A only).
- **Reference material**: `book/lfs/` and `book/blfs/` hold the LFS/BLFS book copies the LFS mode tracks; consult them before changing `scripts1/`..`scripts5/` logic.
- **Formatting**: shell scripts are formatted with `shfmt -l -w .` (tabs; see `.editorconfig`). No automated test suite — verification is "did it build, does it boot in `./run.sh`".

## Rules for AI agents

1. Confirm the mode first. If the user says "the build", "scripts", or "the kernel step" without context, ask or infer from the open file / recent commits.
2. **Never port logic between `scripts0/` and `scripts1/`..`scripts6/`.** They have different source layouts (`src/` vs `src-lfs/`), different source formats (git vs tarballs), and different design goals (self-hosted from-git vs LFS-book-faithful).
3. **In LFS mode, also be careful about porting across stages** — each stage runs in a different rootfs (debian → progressively-built LFS images) with different available tools and a different working directory layout.
4. Edits to `scripts1/`..`scripts5/` should stay aligned with the LFS book unless the user explicitly diverges.
5. The `scripts/` directory holds only orchestration wrappers (`build1.sh`, `build2.sh`, `build-lfs-1.sh`, `build-lfs-2.sh`, `download-src.sh`, `download-src-lfs.sh`) — not build steps.
6. Treat `000-build.sh` in each script dir as the source of truth for what runs and in what order. Filename numbering ≠ execution order.
7. When adding a Mode A dependency, add it to `deps/sources.conf` **and** wire it into `scripts0/000-build.sh` (and write the build script). When adding a Mode B dependency, update `deps/wget-list-systemd` + `deps/md5sums` from the LFS book and call it from the matching `scripts${N}/000-build.sh` for the stage that should build it.
