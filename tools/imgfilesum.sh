#!/bin/bash

dosort() {
	env LC_COLLATE=C sort $@
}

contentsum() {
	local mountpath="${1}"
	local tmpf="${2}"

	pushd ${mountpath} &> /dev/null
	find . | dosort | sha256sum - >> ${tmpf}
	find . -type f -exec sha256sum {} \; | dosort >> ${tmpf}
	popd &> /dev/null
}

sumimage() {
	local imagepath="${1}"
	local lodev=$(losetup -r -P --show -f ${imagepath})
	local tmpf=$(mktemp)

	mount -o ro ${lodev}p2 /mnt
	contentsum /mnt ${tmpf}
	umount /mnt
	losetup -d ${lodev}
	sha256sum ${tmpf} | cut -d' ' -f1
	rm -f ${tmpf}
}

if [ "$(whoami)" != "root" ]; then
	echo "Run me as root!"
	exit 1
fi

if [ -z "${1}" ]; then
	echo "Usage: ./${0} path/to/image.wic"
	exit 1
fi

sumimage ${1}
