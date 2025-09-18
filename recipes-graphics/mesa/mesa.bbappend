PACKAGECONFIG:append:class-target = " \
	broadcom \
	egl \
	gallium \
	gallium-llvm \
	gbm \
	gles \
	imagination \
	lima \
	v3d \
	vc4 \
	"

PACKAGECONFIG:remove:class-target = " \
	dri3 \
	etnaviv \
	freedreno-fdperf \
	glvnd \
	kmsro \
	lmsensors \
	opencl \
	osmesa \
	panfrost \
	perfecto \
	r600 \
	tegra \
	tools \
	unwind \
	vdpau \
	video-codecs \
	virgl \
	vulkan-beta \
	vulkan \
	wayland \
	x11 \
	xa \
	zink \
	"
