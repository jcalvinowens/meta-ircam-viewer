#!/bin/sh

case "$1" in
	start)
		sisyphus ircam -F </dev/null >/dev/null 2>/dev/null &
		;;
	stop)
		kill -TERM $(pgrep -of sisyphus)
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
