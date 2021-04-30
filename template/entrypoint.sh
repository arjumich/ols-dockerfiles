#!/bin/bash
if [ -z "$(ls -A -- "/home/olsuser/lsws/conf/")" ]; then
	cp -R /home/olsuser/lsws/.conf/* /home/olsuser/lsws/conf/
fi
if [ -z "$(ls -A -- "/home/olsuser/lsws/admin/conf/")" ]; then
	cp -R /home/olsuser/lsws/admin/.conf/* /home/olsuser/lsws/admin/conf/
fi
chown olsuser:olsuser /home/olsuser/lsws/conf -R
chown olsuser:olsuser /home/olsuser/lsws/admin/conf -R

/home/olsuser/lsws/bin/lswsctrl start
$@
while true; do
	if ! /home/olsuser/lsws/bin/lswsctrl status | grep 'litespeed is running with PID *' > /dev/null; then
		break
	fi
	sleep 60
done

