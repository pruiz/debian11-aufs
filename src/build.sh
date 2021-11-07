#!/bin/bash

SWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KVERSION=${1:-$(uname -r)}

make -C /lib/modules/${KVERSION}/build SUBDIRS=${SWD}/aufs clean
make -C /lib/modules/${KVERSION}/build SUBDIRS=${SWD}/aufs modules
