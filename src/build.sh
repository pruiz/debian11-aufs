#!/bin/bash

SWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KVERSION=${1:-$(uname -r)}

make KERNELRELEASE=${KVERSION} -C /lib/modules/${KVERSION}/build M=${SWD} clean
make KERNELRELEASE=${KVERSION} -C /lib/modules/${KVERSION}/build M=${SWD} modules
make KERNELRELEASE=${KVERSION} -C /lib/modules/${KVERSION}/build M=${SWD} modules_install
