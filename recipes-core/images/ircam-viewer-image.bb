SUMMARY = "ircam-viewer-image"
DESCRIPTION = "USB Infrared Camera Appliance Firmware"
IMAGE_FSTYPES = "wic"
IMAGE_FEATURES = " "

CORE_IMAGE_EXTRA_INSTALL += " \
	packagegroup-core-boot \
	packagegroup-ircam-kernel-modules-drm \
	packagegroup-ircam-kernel-modules-misc \
	packagegroup-ircam-kernel-modules-v4l \
	ircam-viewer \
	"

IMAGE_INSTALL:remove = " \
	packagegroup-base-extended \
	kernel-modules \
	"

inherit core-image
