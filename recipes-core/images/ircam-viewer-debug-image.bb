SUMMARY = "ircam-viewer-debug-image"
DESCRIPTION = "USB Infrared Camera Appliance Debug Firmware"
IMAGE_FSTYPES = "wic"

IMAGE_FEATURES = " \
	tools-debug \
	tools-sdk \
	dbg-pkgs \
	dev-pkgs \
	doc-pkgs \
	allow-empty-password \
	empty-root-password \
	allow-root-login \
	"

CORE_IMAGE_EXTRA_INSTALL += " \
	packagegroup-core-boot \
	kernel-modules \
	ircam-viewer \
	"

inherit core-image
