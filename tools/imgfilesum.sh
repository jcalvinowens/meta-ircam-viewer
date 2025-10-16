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
	if [ -z "${lodev}" ]; then
		echo "Can't set up block device"
		exit 1
	fi

	# FIXME losetup doesn't wait for partscan to complete... maybe a bug?
	partprobe > /dev/null 2> /dev/null

	local lopart=$(blkid ${lodev}p* | grep ext4 | cut -d':' -f1)
	if [ -z "${lopart}" ]; then
		echo "Can't find root partition"
		exit 1
	fi

	local tmpf=$(mktemp)
	mount -o ro ${lopart} /mnt
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
