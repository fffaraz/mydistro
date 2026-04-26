# mydistro — AI agent context

A from-scratch Linux distribution built entirely from source inside Docker. There are **two completely independent build modes** that share nothing except the top-level `build.sh` dispatcher and the Debian-based `Dockerfile` used to bootstrap pass 1.

Always identify which mode the user's request targets before reading any script. `scripts0/` and `scripts1/`+`scripts2/` are unrelated codebases — do not cross-reference them.

## Mode A — "main" mode (`scripts0/`)

The primary mode. Builds the OS from upstream **git source repositories**.

- **Sources**: `src/` (one subdir per dependency, cloned from upstream git). Listed in `deps/sources.conf`. Downloaded by `scripts/download-src.sh`.
- **Build scripts**: `scripts0/` only. Numbered `000-*.sh` … executed in order by `000-build.sh`.
- **Pass 1** — `scripts/build1.sh`: runs `scripts0/` inside a container based on `debian:sid-slim` (the project `Dockerfile`). Produces `output/initramfs.tar.gz`.
- **Pass 2** — `scripts/build2.sh`: imports `initramfs.tar.gz` as the image `mydistro-initramfs:latest` and re-runs the **same `scripts0/`** inside it. This is the self-hosting step (the OS rebuilds itself).
- **Container mounts** (both passes):
  - `src/` → `/opt/mydistro/src-ro` **read-only**; the build overlays a tmpfs writable layer on top so the host source tree is never modified.
  - `scripts0/` → `/opt/mydistro/scripts` read-only.
  - `assets/` read-only, `output/` writable.

Invoke: `./build.sh`

## Mode B — "LFS" mode (`scripts1/` + `scripts2/`)

Follows the **Linux From Scratch book**, with these deliberate departures from LFS:

- **No real chroot** — each LFS pass runs in its own Docker container instead.
- **Pass 1 container** is `debian:sid-slim` (same `Dockerfile` as Mode A). It builds an LFS-style root filesystem into `output/bootstrap.tar.gz` instead of using a host toolchain + chroot.
- **Pass 2 container** is built by `docker import`-ing `bootstrap.tar.gz` as `mydistro-bootstrap:latest`, then continuing the LFS build inside it. This replaces LFS's `chroot $LFS`.
- **Sources are upstream tarballs** (the LFS-prescribed versions), not git — this is the opposite of Mode A.

Layout:
- **Sources**: `src-lfs/` (tarballs). Downloaded by `scripts/download-src-lfs.sh`.
- **Pass 1 scripts**: `scripts1/` — corresponds roughly to LFS chapters 5–6 (cross-toolchain + temporary tools).
- **Pass 2 scripts**: `scripts2/` — corresponds roughly to LFS chapter 8 onward (final system).
- **Container mounts**: same pattern as Mode A but with `src-lfs/` → `/opt/mydistro/src-ro` read-only + tmpfs overlay; `scripts1/` (pass 1) or `scripts2/` (pass 2) → `/opt/mydistro/scripts`.

Invoke: `./build.sh --lfs`

## Shared mechanics

- **Read-only source + RAM overlay**: in every container, the host source dir is mounted read-only and a writable tmpfs overlay is layered on top, so builds can patch/configure freely without dirtying the host tree.
- **Offline builds**: containers run with `--network none`. All downloads happen on the host before the container starts.
- **Output**: everything lands in `output/` (cleared at the start of each `./build.sh` run). Final artifacts: `bzImage`, `initramfs.cpio.gz`, `initramfs.tar.gz`, `mydistro.iso`, `boot.img`.
- **Run the result**: `./run.sh` boots it under QEMU/KVM.

## Rules for AI agents

1. Confirm the mode first. If the user says "the build", "scripts", or "the kernel step" without context, ask or infer from the open file / recent commits.
2. **Never port logic between `scripts0/` and `scripts1/`+`scripts2/`.** They have different source layouts (`src/` vs `src-lfs/`), different source formats (git vs tarballs), and different design goals (self-hosted from-git vs LFS-book-faithful).
3. Edits to `scripts1/` or `scripts2/` should stay aligned with the LFS book unless the user explicitly diverges.
4. The `scripts/` directory holds only orchestration wrappers (`build1.sh`, `build2.sh`, `build-lfs-1.sh`, `build-lfs-2.sh`, `download-src.sh`, `download-src-lfs.sh`) — not build steps.
