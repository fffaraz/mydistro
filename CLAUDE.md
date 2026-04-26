# mydistro — AI agent context

A from-scratch Linux distribution built entirely from source inside Docker. There are **two completely independent build modes** that share nothing except the top-level `build.sh` dispatcher and the Debian-based `Dockerfile` used to bootstrap pass 1.

Always identify which mode the user's request targets before reading any script. `scripts0/` and `scripts1/`+`scripts2/` are unrelated codebases — do not cross-reference them.

## Mode A — "main" mode (`scripts0/`)

The primary mode. Builds the OS from upstream **git source repositories**.

- **Sources**: `src/` (one subdir per dependency, cloned from upstream git). Listed in `deps/sources.conf`. Downloaded by `scripts/download-src.sh`.
- **Build scripts**: `scripts0/` only. The execution order is dictated by `scripts0/000-build.sh`, **not** by filename ordering. Many scripts in `scripts0/` (e.g. `git.sh`, `ladybird.sh`, `moby.sh`, `podman.sh`, `toybox.sh`, `wlroots.sh`, the `099-*` toolchain rebuilds, alternate `009-musl.sh`) are optional and only run if `000-build.sh` calls them — check there before assuming a script is live.
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

## Mode B — "LFS" mode (`scripts1/` + `scripts2/`)

Follows the **Linux From Scratch book**, with these deliberate departures from LFS:

- **No real chroot** — each LFS pass runs in its own Docker container instead.
- **Pass 1 container** is `debian:sid-slim` (same `Dockerfile` as Mode A). It builds an LFS-style root filesystem into `output/bootstrap.tar.gz` instead of using a host toolchain + chroot.
- **Pass 2 container** is built by `docker import`-ing `bootstrap.tar.gz` as `mydistro-bootstrap:latest`, then continuing the LFS build inside it. This replaces LFS's `chroot $LFS`.
- **Sources are upstream tarballs** (the LFS-prescribed versions), not git — this is the opposite of Mode A.

Layout:
- **Sources**: `src-lfs/` (tarballs). Versions and checksums come straight from the LFS book — `deps/wget-list-systemd` (URLs) + `deps/md5sums` (md5s). Downloaded by `scripts/download-src-lfs.sh`.
- **Pass 1 scripts**: `scripts1/` — corresponds roughly to LFS chapters 5–6 (cross-toolchain + temporary tools). Builds into `$LFS=$(pwd)/rootfs`, exported as `output/bootstrap.tar.gz`. Uses an overlay on `./src` like Mode A.
- **Pass 2 scripts**: `scripts2/` — corresponds roughly to LFS chapter 8 onward (final system). **Note**: `scripts2/000-build.sh` does `cp -r --reflink=auto ./src-ro ./src` instead of an overlay mount (the pass 2 image lacks the kernel module / capabilities for overlayfs in some setups). Same end result — never write to `src-ro`.
- **Container mounts**: same pattern as Mode A but with `src-lfs/` → `/opt/mydistro/src-ro` read-only; `scripts1/` (pass 1) or `scripts2/` (pass 2) → `/opt/mydistro/scripts`.

Invoke: `./build.sh --lfs` (same `-d` / `-n` flags on `build-lfs-1.sh` / `build-lfs-2.sh`).

## Shared mechanics

- **Read-only source + RAM overlay**: in every container, the host source dir is mounted read-only at `./src-ro` and `000-build.sh` exposes a writable copy at `./src` (overlayfs over tmpfs in modes A and B-pass-1; reflink copy in B-pass-2). Builds can patch/configure freely without dirtying the host tree.
- **Offline builds**: containers run with `--network none` and `--privileged` (privileged is needed for the overlay mount). All downloads happen on the host before the container starts.
- **Compiler flags** (set by every `000-build.sh`): `CFLAGS`/`CXXFLAGS` = `-O3 -pipe -march=native -Wno-error`, `MAKEFLAGS=-j$(nproc)`. `-march=native` means built artifacts are tied to the build host's CPU.
- **Architecture**: x86_64 only (hardcoded throughout — kernel target, `qemu-system-x86_64`, `bzImage`, syslinux/grub-x86).
- **Output**: everything lands in `output/` (cleared at the start of each `./build.sh` run). Final artifacts: `bzImage`, `initramfs.cpio.gz`, `initramfs.tar.gz`, `mydistro.iso`, `boot.img`.
- **Run the result**: `./run.sh --cli` (serial console), `--qemu` (graphical ISO boot), or `--docker` (run the initramfs as a container).
- **Reference material**: `book/lfs/` and `book/blfs/` hold the LFS/BLFS book copies the LFS mode tracks; consult them before changing `scripts1/`/`scripts2/` logic.
- **Formatting**: shell scripts are formatted with `shfmt -l -w .` (tabs; see `.editorconfig`). No automated test suite — verification is "did it build, does the ISO boot in `./run.sh`".

## Rules for AI agents

1. Confirm the mode first. If the user says "the build", "scripts", or "the kernel step" without context, ask or infer from the open file / recent commits.
2. **Never port logic between `scripts0/` and `scripts1/`+`scripts2/`.** They have different source layouts (`src/` vs `src-lfs/`), different source formats (git vs tarballs), and different design goals (self-hosted from-git vs LFS-book-faithful).
3. Edits to `scripts1/` or `scripts2/` should stay aligned with the LFS book unless the user explicitly diverges.
4. The `scripts/` directory holds only orchestration wrappers (`build1.sh`, `build2.sh`, `build-lfs-1.sh`, `build-lfs-2.sh`, `download-src.sh`, `download-src-lfs.sh`) — not build steps.
5. Treat `000-build.sh` in each script dir as the source of truth for what runs and in what order. Filename numbering ≠ execution order.
6. When adding a Mode A dependency, add it to `deps/sources.conf` **and** wire it into `scripts0/000-build.sh` (and write the build script). When adding a Mode B dependency, update `deps/wget-list-systemd` + `deps/md5sums` from the LFS book and call it from the matching `scripts1/` or `scripts2/` `000-build.sh`.
