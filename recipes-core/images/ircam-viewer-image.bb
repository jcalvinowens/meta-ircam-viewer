SUMMARY = "ircam-viewer-image"
DESCRIPTION = "USB Infrared Camera Appliance Firmware"
IMAGE_FSTYPES = "wic"

IMAGE_FEATURES = " "
IMAGE_INSTALL = " \
	packagegroup-core-boot \
	packagegroup-ircam-kernel-modules-drm \
	packagegroup-ircam-kernel-modules-misc \
	packagegroup-ircam-kernel-modules-v4l \
	ircam-viewer \
	"

inherit core-image
