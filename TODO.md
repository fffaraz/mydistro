# Dockerfile package minimization

Audit of `Dockerfile` apt packages vs. actual usage in `scripts-build/`.

## High confidence — remove

| Package | Why it's safe |
|---|---|
| `mtools` | Never invoked. `014-mk-boot-img.sh` uses the syslinux `linux/` installer; the `mtools/` variant (and the `036-mtools.sh` build) is commented out. |

## Keep — verified consumers exist

`libelf-dev` (kernel `objtool`), `uuid-dev` (util-linux), `zlib1g-dev`, `bc` (kernel), `cpio` (initramfs), `dosfstools` (`mkfs.vfat` in 014), all autotools (`autoconf`/`automake`/`autopoint`/`libtool`/`m4`/`gperf`/`help2man`/`texinfo`/`gettext`/`pkg-config`/`bison`/`flex`/`gawk`), `xz-utils`/`bzip2`/`zstd`, `git`, `rsync`, `python3`, `file`.
