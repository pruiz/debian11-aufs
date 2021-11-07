#!/bin/bash

set -xe

SWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${SWD}/build-dkms-package.sh"
"${SWD}/build-pmx-packages.sh"

