#!/bin/bash

set -xe

SWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apt-get update
apt-get install -y build-essential devscripts fakeroot quilt dh-make automake libdistro-info-perl less dkms
cd "$SWD"
dpkg-buildpackage
mv ../*.deb packages

