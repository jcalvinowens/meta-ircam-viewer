# Yocto layer for ircam-viewer

This is firmware for an infrared camera appliance built around
[ircam-viewer](https://github.com/jcalvinowens/ircam-viewer?tab=readme-ov-file#linux-infrared-camera-viewer).
It supports x86 UEFI PCs, and all Raspberry Pi models.

Pre-built disk images are available for download on
[Github Releases](https://github.com/jcalvinowens/meta-ircam-viewer/releases).

![](https://static.wbinvd.org/img/ircam/appliance.jpg)

I personally use this on older Intel Atom NUCs, and on the Raspberry Pi Zero W.
While I've tried to make everything as generic as possible, it has almost zero
testing outside those platforms at this point. See KNOWN ISSUES below.

Both this Yocto layer and [ircam-viewer](https://github.com/jcalvinowens/ircam-viewer)
itself are GPLv3 licensed.

## Building

Building this firmware with Yocto should take under an hour on a typical PC
suitable for modern video games. The result of the build process is a bootable
disk image you can simply `dd` to bootable media for your target device.

### 1. Install Yocto

Follow [these instructions](https://docs.yoctoproject.org/ref-manual/system-requirements.html#required-packages-for-the-build-host)
to set up your Linux machine to run Yocto builds.

### 2. Install Kas

This repository uses [kas](https://kas.readthedocs.io/en/latest/) to manage the
Yocto layer dependencies and configs. Most distros support installing a recent
enough version through the package manager, or you can use pip:

```
sudo apt-get install kas  # Debian/Ubuntu
sudo emerge dev-build/kas # Gentoo
pip3 install kas # pip
```

You can also run it directly from [the git repo](https://github.com/siemens/kas.git),
using the `run-kas` shortcut in its root directory.

### 3. Build it

Once you've installed kas, run `kas menu`, select your desired target, and
select "BUILD" to kick off a build!

You can also build without the menu directly from the command line as follows:

* `KAS_MACHINE=genericx86-64 kas build kas/generic.yml`
* `KAS_MACHINE=genericx86 kas build kas/generic.yml`
* `KAS_MACHINE=genericarm64 kas build kas/generic.yml`
* `KAS_MACHINE=raspberrypi kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi0 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi0-wifi kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi0-2w-64 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi2 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi3-64 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi4-64 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi5 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi-armv7 kas build kas/rpi.yml`
* `KAS_MACHINE=raspberrypi-armv8 kas build kas/rpi.yml`

### 4. Flash the image

After the build process successfully completes, the new image will appear at:

```
./build/tmp/deploy/images/${MACHINE}/ircam-viewer-image-${MACHINE}.rootfs.wic
```

You can treat this as a flat disk image, and use `dd` to write it to bootable
media for your target:

```
sudo dd if=ircam-viewer-image-blah.rootfs.wic of=/dev/mmcblk0 status=progress
```

### Using the appliance

The GUI will start within a few seconds when you connect your supported USB IR
camera. It is controlled via the keyboard: refer to the ircam-viewer
[README](https://github.com/jcalvinowens/ircam-viewer/blob/master/README.md#viewing)
for details on how to use it.

### Reproducing Releases

The confugiration used to build each release is saved in `kas/releases`: these
are identical to the base configuration at the time, but with pinned Git SHAs.

```
git checkout --detach v0.1
KAS_MACHINE=genericx86-64 kas build kas/releases/v0.1-generic.yml
KAS_MACHINE=raspberrypi0-wifi kas build kas/releases/v0.1-rpi.yml
KAS_MACHINE=raspberrypi5 kas build kas/releases/v0.1-rpi.yml
```

Yocto supports reproducible disk images, so if everything is working correctly,
the build output on your machine should be binary identical to the image you
downloaded from the releases page.

## KNOWN ISSUES

* Performance on the Raspberry Pi 4b specifically is so poor it is unusable
* Recording almost immediately fills the disk: need to expand on first boot
* Video cards on PCs other than i915 will not have their kernel module loaded
* The x86-x32 build doesn't work due to v4l ioctl problems I need to look into
* Logic for debug target should live in Yocto not Kas
