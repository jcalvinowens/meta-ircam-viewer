SUMMARY = "ircam-viewer-debug-image"
DESCRIPTION = "USB Infrared Camera Appliance Debug Firmware"
IMAGE_FSTYPES = "wic"

IMAGE_FEATURES = " \
	tools-debug \
	dbg-pkgs \
	allow-empty-password \
	empty-root-password \
	allow-root-login \
	"

IMAGE_INSTALL = " \
	packagegroup-core-boot \
	kernel-modules \
	ircam-viewer \
	"

inherit core-image
