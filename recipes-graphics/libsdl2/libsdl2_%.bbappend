PACKAGECONFIG:append:class-target = " gles2 kmsdrm libusb"
PACKAGECONFIG:remove:class-target = " \
	alsa \
	directfb \
	jack \
	libsamplerate \
	libdecor \
	opengl \
	pipewire \
	pulseaudio \
	vulkan \
	wayland \
	x11 \
	"
