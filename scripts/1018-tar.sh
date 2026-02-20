#!/bin/bash
set -exuo pipefail

cd ./src/tar

rmdir paxutils || true
rm paxutils || true
ln -s ../paxutils ./paxutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
echo 'verror' >> gnulib.modules
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

echo '#include <sys/ioctl.h>' > lib/system-ioctl.h

# Fix type mismatch: paxutils uses idx_t, tar uses size_t/ssize_t
sed -i 's/void write_error_details (char const \*name, size_t status, size_t size)/void write_error_details (char const *name, idx_t status, idx_t size)/' src/common.h
sed -i 's/_Noreturn void write_fatal_details (char const \*name, ssize_t status, size_t size)/_Noreturn void write_fatal_details (char const *name, idx_t status, idx_t size)/' src/common.h
sed -i 's/write_fatal_details (char const \*name, ssize_t status, size_t size)/write_fatal_details (char const *name, idx_t status, idx_t size)/' src/buffer.c
sed -i '/#include <termios.h>/a #include <sys/time.h>' src/checkpoint.c

# Fix missing headers and macros for newer gnulib
sed -i '/^#include "tar.h"/a \
#include <ctype.h>\
#ifndef ISDIGIT\
# define ISDIGIT(c) ((unsigned) (c) - '\''0'\'' <= 9)\
#endif\
#ifndef ISODIGIT\
# define ISODIGIT(c) ((unsigned) (c) - '\''0'\'' <= 7)\
#endif' src/common.h

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) \
            --disable-nls \
            CFLAGS="-Wno-error"

make
make DESTDIR=$LFS install
