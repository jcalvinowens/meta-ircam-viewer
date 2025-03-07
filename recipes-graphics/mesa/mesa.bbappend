PACKAGECONFIG:append = " broadcom egl gallium gbm gles lima v3d vc4"
PACKAGECONFIG:remove = " \
	dri3 \
	etnaviv \
	freedreno-fdperf \
	gallium-llvm \
	glvnd \
	imagination \
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
