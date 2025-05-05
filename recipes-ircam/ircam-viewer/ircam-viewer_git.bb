SUMMARY = "ircam-viewer"
LICENSE = "GPL-3.0-or-later"
DESCRIPTION = "Minimalist SDL2 GUI for USB infrared cameras"
HOMEPAGE = "https://github.com/jcalvinowens/ircam-viewer/blob/master/README.md"
SRC_URI = "git://github.com/jcalvinowens/ircam-viewer;protocol=https;nobranch=1"
MIRRORS = "git://codeberg.org/jcalvinowens/ircam-viewer;protocol=https;nobranch=1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"
SRCREV = "5801a2306a3fdd074fe3d37b9d94af8a8371a2b8"
S = "${WORKDIR}/git"

DEPENDS = "libav libsdl2 libsdl2-ttf"
RDEPENDS:${PN} = "libdrm libegl libgbm libgles2 libudev"

F = "${WORKDIR}/sources-unpack"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://modules.sh file://ircam.sh"
FILES:${PN} += "${sysconfdir}/init.d/modules.sh ${sysconfdir}/init.d/ircam.sh"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/ircam ${D}${bindir}
	install -m 0755 ${S}/util/sisyphus ${D}${bindir}
	install -m 0755 ${S}/util/kfwd ${D}${bindir}

	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${F}/modules.sh ${D}${sysconfdir}/init.d/
	install -m 0755 ${F}/ircam.sh ${D}${sysconfdir}/init.d/

	install -d ${D}${sysconfdir}/rcS.d
	ln -s ${sysconfdir}/init.d/modules.sh \
		${D}${sysconfdir}/rcS.d/S10modules.sh
	ln -s ${sysconfdir}/init.d/ircam.sh \
		${D}${sysconfdir}/rcS.d/S95ircam.sh
}

# FIXME: For the pre-built font, which I want to replace with fontconfig...
LICENSE += "| Bitstream-Vera"
LIC_FILE_CHKSUM += " \
	file://fonts/deja_vu_sans_mono.ttf;md5=fc5cedc1b787121cf4ab5895a6ed4d05 \
	file://fonts/LICENSE;md5=449b2c30bfe5fa897fe87b8b70b16cfa \
	"
