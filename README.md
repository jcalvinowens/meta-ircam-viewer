# Yocto Layer for Infrared Camera Appliance

This layer builds a minimalist Linux firmware which runs
[ircam-viewer](https://github.com/jcalvinowens/ircam-viewer?tab=readme-ov-file#linux-infrared-camera-viewer),
allowing you to create cheap "appliances" for displaying or recording output
from commonly avaliable USB infrared cameras (typically designed to be plugged
into cell phones).

![](https://static.wbinvd.org/img/ircam/appliance.jpg)

It currently supports generic x86 UEFI PCs and all\*\* Raspberry Pi models.

\*\* Note that the Pi 4b/5 and Zero-2W are known to have very poor performance:
see KNOWN ISSUES below. The currently recommended board is the Raspberry Pi Zero
or Zero W (buy
[here](https://www.alibaba.com/product-detail/Hotsale-Raspberry-Pi-Zero-W-Board_60711854498.html)
or [here](https://www.aliexpress.us/item/3256805605866860.html)
or [here](https://www.amazon.com/dp/B0C5BC6K6G/)).

## Downloadable Disk Images

Bootable disk images are available for download
[on Github](https://github.com/jcalvinowens/meta-ircam-viewer/releases). Write
them to bootable media like this:

```
$ xzcat ircam-viewer-image-genericx86-64.rootfs-20250307072015.wic.xz | sudo dd of=/dev/${DISK} status=progress
```

...replacing `${DISK}` with the appropriate device on your system (probably
`mmcblk0` or `sda`).

You can inspect or modify the contents of the images like this:

```
$ unxz ircam-viewer-image-genericx86-64.rootfs-20250307072015.wic.xz
$ sudo losetup --show -P -f ircam-viewer-image-genericx86-64.rootfs-20250307072015.wic
/dev/loop13
$ lsblk /dev/loop13
NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop13       7:0    0 215.2M  0 loop
├─loop13p1 259:5    0  28.7M  0 part
├─loop13p2 259:6    0 141.2M  0 part
└─loop13p3 259:7    0    44M  0 part
$ sudo mount /dev/loop13p2 /mnt
```

## Using the Appliance

The GUI will start within a few seconds when you connect your supported USB IR
camera. It is controlled via the keyboard: refer to the ircam-viewer
[README](https://github.com/jcalvinowens/ircam-viewer/blob/master/README.md#viewing)
for details on how to use it.

## Building Disk Images

Building this firmware with Yocto should take under an hour on a typical PC
suitable for modern video games. The result of the build process is a bootable
disk image you can simply `dd` to bootable media for your target device.

### 1. Install Yocto

Follow [these instructions](https://docs.yoctoproject.org/ref-manual/system-requirements.html#required-packages-for-the-build-host)
to set up your Linux machine to run Yocto builds. In addition to the list of
officially supported distributions, Gentoo and Debian Trixie are known to work.

### 2. Install Kas

This layer uses [kas](https://kas.readthedocs.io/en/latest/) to manage the
Yocto layer dependencies and configs. Most distros support installing a recent
enough version through the package manager, or you can use pip:

```
sudo apt-get install kas  # Debian/Ubuntu
sudo emerge dev-build/kas # Gentoo
pip3 install kas # Pip
```

You can also run it directly from [the git repo](https://github.com/siemens/kas.git),
using the `run-kas` shortcut in its root directory.

### 3. Build it

Once you've installed kas, run `kas menu`, select your desired target, and
select "BUILD" to kick off a build!

You can also build without the menu directly from the command line as follows:

* `KAS_MACHINE=genericx86-64 kas build kas/generic.yml`
* `KAS_MACHINE=beaglebone-yocto kas build kas/generic.yml`
* `KAS_MACHINE=raspberrypi0 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi0-wifi kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi-armv7 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi-armv8 kas build kas/rpi.yml`

The default configuration uses `/var/tmp/yocto_dl` as the DL\_DIR to cache
downloaded source tarballs.

### 4. Flash the image

After the build process successfully completes, the new images will appear at:

```
./build/tmp/deploy/images/${MACHINE}/ircam-viewer-image-${MACHINE}.rootfs.wic
./build/tmp/deploy/images/${MACHINE}/ircam-viewer-debug-image-${MACHINE}.rootfs.wic
```

The images are identical, except that the "debug" image has no root password,
contains debugging utilities like `gdb` and `strace`, and contains the full set
of kernel modules.

Use `dd` to write your desired image to bootable media for your target:

```
sudo dd if=ircam-viewer-image-blah.rootfs.wic of=/dev/mmcblk0 status=progress
```

## Reproducing Releases

The confugiration used to build each release is saved in `kas/releases`: these
are identical to the base configuration at the time, but with pinned git SHAs.

```
git checkout --detach vXXX
KAS_MACHINE=genericx86-64 kas build kas/releases/vXXX-generic.yml
KAS_MACHINE=raspberrypi0 kas build kas/releases/vXXX-rpi.yml
KAS_MACHINE=raspberrypi0-wifi kas build kas/releases/vXXX-rpi.yml
KAS_MACHINE=raspberrypi-armv7 kas build kas/releases/vXXX-rpi.yml
KAS_MACHINE=raspberrypi-armv8 kas build kas/releases/vXXX-rpi.yml
```

Yocto builds reproducible binaries, but the disk images will not be identical
because the filesystem creation is non-deterministic. If you mount and compare
the actual file content of the downloaded images with images built per above,
the files should be exactly identical: the `tools/imgfilesum.sh` script will do
that for you. The checksums for each release are published in the release notes.

The releases have their login consoles disabled by adding `noconsoles.yml`.

## Known Issues

* Performance on the Raspberry Pi 4b/5 is so poor they are unusable
* Recording almost immediately fills the disk: need to expand on first boot
* Video cards on PCs other than i915 will not have their kernel module loaded
* The x86-x32 build doesn't work due to v4l ioctl problems I need to look into
* The program segfaults in libgallium on beaglebone/pizero when built with musl
* The program fails to initialize the framebuffer on the Beaglebone Black

## Licensing

```
Copyright (C) 2025 Calvin Owens <calvin@wbinvd.org>
SPDX-License-Identifier: GPL-3.0-or-later
```

Both this layer and [ircam-viewer](https://github.com/jcalvinowens/ircam-viewer)
itself are released under version 3.0 of the GNU General Public License.

The `commercial_ffmpeg` license is accepted on all builds: it is *your*
responsibility to determine if commercial licensing is required for your usecase
in your jurisdiction. The program creates Matroska files encoded with FFV1,
using libavformat and libavcodec.

On Raspberry Pi builds, the `synaptics-killswitch` license is accepted: refer to
[this page](https://meta-raspberrypi.readthedocs.io/en/latest/ipcompliance.html)
for details.
