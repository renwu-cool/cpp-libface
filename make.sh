#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT

if [ ! -f "./deps/libuv/Makefile" ]; then
git submodule update --init --recursive
fi
mkdir -p server
rm -rf server/*

export CFLAGS=-Wno-implicit-fallthrough
make
mv lib-face server/name

make COPT="-D UNIQUE_BY_ID=1"
make
mv lib-face server/id
