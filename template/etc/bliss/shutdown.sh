#!/bin/sh

if [ ! -z "$(which dbus-send)" ]; then
  SHUTDOWN="dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop"
else
  SHUTDOWN="/bin/sh -c '/bin/echo give root password for POWEROFF or press C-d to exit; /bin/su -c /sbin/poweroff'"
fi
gxmessage -nearmouse -buttons "Yes:3,No:4" -name "Power off" "Shutdown?"
case $? in
3) ${SHUTDOWN} ;;
*) echo "abort Shutdown" ;;
esac
