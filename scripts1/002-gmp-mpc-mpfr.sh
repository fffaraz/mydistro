#!/bin/bash
set -exuo pipefail

cd ./src

tar xf gmp-*.tar.*
mv gmp-*/ gmp

tar xf mpc-*.tar.*
mv mpc-*/ mpc

tar xf mpfr-*.tar.*
mv mpfr-*/ mpfr
