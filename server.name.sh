#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT

if [ ! -f "./server/name" ]; then
../make.sh
fi
if [ ! -f "./server/name.tsv" ]; then
../data.py
fi

cd server
./name -f name.tsv
