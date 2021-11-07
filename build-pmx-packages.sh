#!/bin/bash

set -xe

SWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 'deb http://download.proxmox.com/debian/pve stretch pve-no-subscription' >> /etc/apt/sources.list
apt-get update
apt-get install -y dkms build-essential devscripts fakeroot quilt dh-make

PKGS=$(apt-cache search pve-headers-* 2>/dev/null|egrep -v '(Latest|Default|^pve-headers-4.10.|^pve-headers-4.13.)' |cut -d ' ' -f 1)

apt-get remove -y linux-headers-*
apt-get install -y --allow-unauthenticated $PKGS

cd "$SWD"

dpkg -i packages/aic94xx-dkms_*.deb

SCRIPT=$(mktemp /tmp/build-XXXXXXX.sh)
cat <<-_EOF > "${SCRIPT}"
	#!/bin/bash

	set -xe
_EOF

dkms status aic94xx|sed -e 's/^/dkms mkbmdeb /' -e 's/, /\//' -e 's/, / -k /' -e 's/,.*/;/' >> "${SCRIPT}"

chmod +x "${SCRIPT}"
"${SCRIPT}"

PKGS=$(find /var/lib/dkms/aic94xx/  -name '*.deb')
cp $PKGS packages/
