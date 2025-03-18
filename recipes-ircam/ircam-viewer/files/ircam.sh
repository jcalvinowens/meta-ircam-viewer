#!/bin/sh

case "$1" in
	start)
		touch /ircam
		sh -c '
		while [ -e /ircam ]; do
			for vdev in /dev/video*; do
				ircam -F -d ${vdev}
				sleep 0.1
			done
		done' >/dev/null 2>&1 </dev/null &
		;;
	stop)
		rm -f /ircam
		killall ircam
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
