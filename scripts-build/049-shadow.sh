#!/usr/bin/bash
set -exuo pipefail

cd ./src/shadow

# Building from a git checkout: regenerate the autotools build system.
# shadow's own autogen.sh would also force a long list of -Werror flags and
# then run ./configure itself — we only want the bootstrap, so call autoreconf
# directly and let 000-build.sh's -Wno-error CFLAGS stand.
autoreconf -v -f --install

# Match LFS's login.defs tweaks: default new passwords to the modern yescrypt
# hash, use the FHS mail spool, and drop the /sbin:/bin PATH duplication.
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
	-e 's:/var/spool/mail:/var/mail:' \
	-e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
	-i etc/login.defs

# coreutils already provides a better `groups`; suppress shadow's copy.
sed -i 's/groups$(EXEEXT) //' src/Makefile.in

# --without-libbsd: glibc has no readpassphrase(), and we don't build libbsd,
#   so use shadow's bundled fallback (this also skips the configure-time probe).
# --with-yescrypt: enable the yescrypt hash (libxcrypt from 028 provides it).
# --without-libpam: shadow defaults to "use PAM if found", and the pass-1 debian
#   build host may have it — but this distro ships no PAM stack or /etc/pam.d, so
#   force shadow's built-in /etc/passwd + /etc/shadow auth (login_nopam) instead.
# --disable-logind: the logind integration only *queries* sessions via libsystemd
#   (which lives only in the OS image, not the pass-1 build container). Session
#   *registration* is pam_systemd's job, which we don't have (--without-libpam),
#   so the integration would query sessions nothing ever creates — drop it.
# Man pages live under `if ENABLE_REGENERATE_MAN` (xsltproc/docbook); leaving
#   --enable-man off drops the whole man/ subdir, so no docbook toolchain needed.
# --prefix=/usr: shadow zeroes exec_prefix for a /usr prefix, so `login` (its
#   one bin_PROGRAMS entry) installs to /bin/login — exactly where agetty's
#   compiled-in _PATH_LOGIN expects it. This provides the /bin/login that
#   util-linux's --disable-login left missing.
./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--with-group-name-max-length=32 \
	--with-yescrypt \
	--without-libbsd \
	--without-libpam \
	--disable-logind \
	--disable-static

make
make install DESTDIR=$INITRAMFS_DIR
