# Dockerfile package minimization

Audit of `Dockerfile` apt packages vs. actual usage in `scripts-build/`.

## High confidence — remove

| Package | Why it's safe |
|---|---|
| `mtools` | Never invoked. `014-mk-boot-img.sh` uses the syslinux `linux/` installer; the `mtools/` variant (and the `036-mtools.sh` build) is commented out. |

## Medium confidence — remove with a tiny tweak

- **`nasm`** — needed for `005-syslinux.sh`. `030-nasm.sh` runs first but only does `make install DESTDIR=$INITRAMFS_DIR` (not on host PATH). Add a plain `make install` to that script and host `nasm` becomes redundant.
- **`python-is-python3`** — `python3` stays. We already removed `*.menu` files that would invoke `python` in syslinux. Worth grepping `src/` post-clone for stray shebangs, but no active script in `scripts-build/` calls bare `python`.
- **`libzstd-dev`** — kernel needs the `zstd` *binary* for `KERNEL_ZSTD` (keep `zstd`), but no script links against libzstd before `015-zstd.sh` builds it. `017-elfutils.sh` configures `--without-zstd`. Likely safe.

## Keep — verified consumers exist

`libncurses-dev` (nano runs before the 099-ncurses rebuild), `libssl-dev` (kernel sign-file / openssl bootstrap timing), `libelf-dev` (kernel `objtool`), `libcrypt-dev` (perl), `uuid-dev` (util-linux), `zlib1g-dev`, `bc` (kernel), `cpio` (initramfs), `dosfstools` (`mkfs.vfat` in 014), all autotools (`autoconf`/`automake`/`autopoint`/`libtool`/`m4`/`gperf`/`help2man`/`texinfo`/`gettext`/`pkg-config`/`bison`/`flex`/`gawk`), `xz-utils`/`bzip2`/`zstd`, `git`, `rsync`, `python3`, `file`.
