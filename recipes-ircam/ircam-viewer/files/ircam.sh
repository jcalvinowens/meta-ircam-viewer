#!/bin/sh

case "$1" in
    start)
	touch /runircam
	sh -c '
	while [ -e /runircam ]; do
		for vdev in /dev/video*; do
			ircam -F -d ${vdev} 2>&1 > /dev/null
			sleep 0.1
		done
		sleep 1
	done
	' & ;;
    stop) rm /runircam ;;
    *) echo "Usage: $0 {start|stop}"; exit 1 ;;
esac
