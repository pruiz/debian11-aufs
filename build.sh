#!/bin/bash

git submodule update --init --recursive

docker run -it --rm -v $(pwd):/sources debian:11 /sources/build-all.sh
