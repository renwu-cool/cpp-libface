#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT

if [ ! -f "./server/id" ]; then
../make.sh
fi
if [ ! -f "./server/id.tsv" ]; then
../data.py
fi

cd server
./id -f id.tsv
