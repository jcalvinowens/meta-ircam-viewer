# Yocto Layer for Infrared Camera Appliance

This layer builds a minimalist Linux firmware which runs
[ircam-viewer](https://github.com/jcalvinowens/ircam-viewer?tab=readme-ov-file#linux-infrared-camera-viewer),
creating a cheap "appliance" for displaying or recording output from commonly
available USB infrared cameras.

![](https://static.wbinvd.org/img/ircam/appliance.jpg)

The firmware currently supports generic x86 UEFI PCs, and all\*\* Raspberry Pi
models.

\*\* Note that the Pi 4b/5 and Zero-2W are known to have very poor performance:
see KNOWN ISSUES below. The currently recommended board is the Raspberry Pi Zero
or Zero W (buy
[here](https://www.alibaba.com/product-detail/Hotsale-Raspberry-Pi-Zero-W-Board_60711854498.html)
or [here](https://www.aliexpress.us/item/3256805605866860.html)
or [here](https://www.amazon.com/dp/B0C5BC6K6G/)).

## Downloadable Disk Images

Bootable disk images are available for download
[on Github](https://github.com/jcalvinowens/meta-ircam-viewer/releases) and
[on Codeberg](https://codeberg.org/jcalvinowens/meta-ircam-viewer/releases).
Write them to bootable media like this:

```
$ xzcat ircam-viewer-image-genericx86-64.rootfs-20250307072015.wic.xz | sudo dd of=/dev/${DISK} status=progress
```

...replacing `${DISK}` with the appropriate device on your system (probably
`mmcblk0` or `sda`).

## Using the Appliance

The GUI will start within a few seconds when you connect your supported USB IR
camera. It is controlled via the keyboard: refer to the ircam-viewer
[README](https://github.com/jcalvinowens/ircam-viewer/blob/master/README.md#viewing)
for details on how to use it.

## Building Disk Images

Building this firmware with Yocto should take under an hour on a typical PC
suitable for modern video games. The result of the build process is a bootable
disk image you can simply `dd` to bootable media for your target device.

### 1. Set up for Yocto

If you run Linux, ensure your machine meets the [minimum requirements](https://docs.yoctoproject.org/dev-manual/start.html#setting-up-a-native-linux-host), and install the [required packages](https://docs.yoctoproject.org/ref-manual/system-requirements.html#required-packages-for-the-build-host).

If you don't run Linux, you can [use WSL on Windows](https://docs.yoctoproject.org/dev-manual/start.html#setting-up-to-use-windows-subsystem-for-linux-wsl-2), [use CROPS containers on Mac](https://docs.yoctoproject.org/dev-manual/start.html#setting-up-to-use-cross-platforms-crops), or simply run Linux in a VM and follow the above instructions.

### Set up Kas

This repository uses [kas](https://kas.readthedocs.io/en/latest/) to manage the
Yocto layer dependencies and configs. Most distros support installing a recent
enough version through the package manager, or you can use pip:

```
sudo apt-get install kas  # Debian/Ubuntu
sudo emerge dev-build/kas  # Gentoo
pip3 install kas  # Pip
```

You can also run it directly from a local checkout of
[the git repo](https://github.com/siemens/kas.git), using the `run-kas` shortcut
in its root directory. You can manually install its dependecies through the
package manager:

```
sudo apt install python3-distro python3-yaml python3-jsonschema python3-git python3-gnupg  # Debian/Ubuntu
sudo emerge dev-python/distro dev-python/pyaml dev-python/jsonschema dev-python/gitpython dev-python/python-gnupg  # Gentoo
```

### 3. Build it

Run `kas build` to kick off an x86-64 build!

You can build for other targets by specifying them on the command line:

* `kas build --target mc:x86-64:ircam-viewer-image`
* `kas build --target mc:x86-64-x32:ircam-viewer-image`
* `kas build --target mc:x86:ircam-viewer-image`
* `kas build --target mc:arm64:ircam-viewer-image`
* `kas build --target mc:beaglebone-yocto:ircam-viewer-image`
* `kas build --target mc:raspberrypi:ircam-viewer-image`
* `kas build --target mc:raspberrypi0:ircam-viewer-image`
* `kas build --target mc:raspberrypi0-wifi:ircam-viewer-image`
* `kas build --target mc:raspberrypi2:ircam-viewer-image`
* `kas build --target mc:raspberrypi3-64:ircam-viewer-image`
* `kas build --target mc:raspberrypi4-64:ircam-viewer-image`
* `kas build --target mc:raspberrypi0-2w-64:ircam-viewer-image`
* `kas build --target mc:raspberrypi5:ircam-viewer-image`
* `kas build --target mc:raspberrypi-armv7:ircam-viewer-image`
* `kas build --target mc:raspberrypi-armv8:ircam-viewer-image`

...or build for all supported targets by passing the template YAML:

```
kas build kas/template.yaml
```

The default configuration uses `/var/tmp/yocto_dl` as the DL\_DIR to cache
downloaded source tarballs.

### 4. Flash the image

After the build process successfully completes, the image(s) will appear at:

```
./build/tmp/deploy/images/${MACHINE}/ircam-viewer-image-${MACHINE}.rootfs.wic
./build/tmp/deploy/images/${MACHINE}/ircam-viewer-debug-image-${MACHINE}.rootfs.wic
```

The "debug" image has no root password, contains debugging utilities like `gdb`
and `strace`, and contains the full set of kernel modules.

Use `dd` to write your desired image to bootable media for your target:

```
sudo dd if=ircam-viewer-image-blah.rootfs.wic of=/dev/mmcblk0 status=progress
```

## Reproducing Releases

The confugiration used to build each release is saved in `kas/releases`: these
are identical to the base configuration at the time, but with pinned git SHAs.

```
git checkout --detach vXXX
kas build kas/releases/vXXX.yml --target mc:raspberrypi0:ircam-viewer-image
```

Yocto builds reproducible binaries, but the disk images will not be identical
because the filesystem creation is non-deterministic. If you mount and compare
the actual file content of the downloaded images with images built per above,
the files should be exactly identical: the `tools/imgfilesum.sh` script will do
that for you. The checksums for each release are published in the release notes.

The releases have their login consoles disabled by adding `noconsoles.yml`. The
canned release YAML is autogenerated by `tools/release.py`.

Note that the images for x86-64 and x86-64-32 builds end up in different TMPDIRs
but have identical filenames.

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
