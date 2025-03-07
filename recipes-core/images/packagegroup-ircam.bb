inherit packagegroup

PACKAGES = " \
	${PN}-kernel-modules-v4l \
	${PN}-kernel-modules-drm \
	${PN}-kernel-modules-misc \
	"

RRECOMMENDS:${PN}-kernel-modules-v4l = " \
	kernel-module-uvc \
	kernel-module-uvcvideo \
	kernel-module-video \
	kernel-module-videobuf2-common \
	kernel-module-videobuf2-memops \
	kernel-module-videobuf2-v4l2 \
	kernel-module-videobuf2-vmalloc \
	kernel-module-videodev \
	"

RRECOMMENDS:${PN}-kernel-modules-drm = " \
	kernel-module-drm-buddy \
	kernel-module-drm-display-helper \
	kernel-module-i915 \
	kernel-module-v3d \
	kernel-module-vc4 \
	"

RRECOMMENDS:${PN}-kernel-modules-misc = " \
	kernel-module-mc \
	kernel-module-ttm \
	kernel-module-wmi \
	"
