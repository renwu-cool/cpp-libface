#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT/server

if [ ! -f "./name" ]; then
../make.sh
fi

if [ ! -f "./name.tsv" ]; then
../data.py
fi

./name -f name.tsv
