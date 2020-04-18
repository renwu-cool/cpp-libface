#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT/server

if [ ! -f "./id" ]; then
../make.sh
fi
if [ ! -f "./id.tsv" ]; then
../data.py
fi

./id -f id.tsv
