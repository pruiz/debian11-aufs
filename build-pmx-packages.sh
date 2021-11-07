#!/bin/bash

set -xe

SWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 'deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription' >> /etc/apt/sources.list
curl -o /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg http://download.proxmox.com/debian/proxmox-release-bullseye.gpg
apt-get update
apt-get install -y dkms build-essential devscripts fakeroot quilt dh-make dialog
apt-get remove -y linux-headers-*


PKGS=$(apt-cache search pve-headers-* 2>/dev/null|grep -F 'pve-headers-5.11.'|egrep -v '5\.11\.(0-1|7-1|12-1)-pve' |cut -d ' ' -f 1)
apt-get install -y $PKGS

cd "$SWD"
dpkg -i packages/aufs-dkms_*.deb

SCRIPT=$(mktemp /tmp/build-XXXXXXX.sh)
cat <<-_EOF > "${SCRIPT}"
	#!/bin/bash

	set -xe
_EOF

dkms status aufs|sed -e 's/^/dkms mkbmdeb /' -e 's/, /\//' -e 's/, / -k /' -e 's/,.*/;/' >> "${SCRIPT}"

chmod +x "${SCRIPT}"
"${SCRIPT}"

PKGS=$(find /var/lib/dkms/aufs/  -name '*.deb')
cp $PKGS packages/
