#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT

if [ ! -f "./lib-face" ]; then
./make.sh
fi

./lib-face -f data.tsv
