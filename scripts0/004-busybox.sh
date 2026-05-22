#!/bin/bash
set -exuo pipefail

cd ./src/busybox

make defconfig

sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
sed -i 's/CONFIG_TC=y/CONFIG_TC=n/' .config

# Disable applets provided by coreutils (099-coreutils.sh) and diffutils (099-diffutils.sh).
# coreutils is configured with --enable-install-program=hostname --enable-no-install-program=kill,uptime,
# so busybox keeps KILL and UPTIME but loses HOSTNAME.
disabled_applets=(
	BB_ARCH BASE32 BASE64 BASENAME CAT CHGRP CHMOD CHOWN CHROOT CKSUM
	COMM CP CUT DATE DD DF DIRNAME DU ECHO ENV EXPAND EXPR FACTOR FALSE
	FOLD GROUPS HEAD HOSTID HOSTNAME ID INSTALL LINK LN LOGNAME LS
	MD5SUM MKDIR MKFIFO MKNOD MKTEMP MV NICE NL NOHUP NPROC OD PASTE
	PRINTENV PRINTF PWD READLINK REALPATH RM RMDIR SEQ SHA1SUM SHA256SUM
	SHA512SUM SHRED SHUF SLEEP SORT SPLIT STAT STTY SUM SYNC TAC TAIL
	TEE TEST TEST1 TIMEOUT TOUCH TR TRUE TRUNCATE TSORT TTY UNAME
	UNEXPAND UNIQ UNLINK USERS WC WHO WHOAMI YES
	CMP DIFF
)
for applet in "${disabled_applets[@]}"; do
	sed -i "s/^CONFIG_${applet}=y$/# CONFIG_${applet} is not set/" .config
done

make
make CONFIG_PREFIX=$INITRAMFS_DIR install
