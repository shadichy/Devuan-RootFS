#!/bin/sh

gxmessage -nearmouse -buttons "Yes:3,No:4" -name "Restart" "Reboot?"
case $? in
3) /sbin/reboot ;;
*) echo "abort Reboot" ;;
esac
