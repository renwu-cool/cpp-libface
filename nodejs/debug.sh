#!/usr/bin/env bash

ROOT=$(cd "$(dirname "$0")"; pwd)
cd $ROOT
yarn run debug
