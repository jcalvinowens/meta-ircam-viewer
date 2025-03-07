#!/bin/sh

case "$1" in
	start)
		modprobe i915
		modprobe vc4
		modprobe uvcvideo
		;;
	stop) true ;;
	*) echo "Usage: $0 {start|stop}"; exit 1 ;;
esac
