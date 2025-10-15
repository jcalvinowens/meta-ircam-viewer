FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"
SRC_URI += "${@bb.utils.contains('DEFAULTTUNE', 'x86-64-x32', 'file://0001-efi-stub-out-__grub_efi_api-when-GRUB_UTIL-is-define.patch', '', d)}"
