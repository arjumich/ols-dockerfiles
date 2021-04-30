#!/bin/bash
if [ -z "$(ls -A -- "/home/olsuser/tmp/lsws/conf/")" ]; then
	cp -R /home/olsuser/tmp/lsws/.conf/* /home/olsuser/tmp/lsws/conf/
fi
if [ -z "$(ls -A -- "/home/olsuser/tmp/lsws/admin/conf/")" ]; then
	cp -R /home/olsuser/tmp/lsws/admin/.conf/* /home/olsuser/tmp/lsws/admin/conf/
fi


#chown olsuser:olsuser /home/olsuser/tmp/lsws/conf -R
#chown olsuser:olsuser /home/olsuser/tmp/lsws/admin/conf -R

mkdir -p /home/olsuser/lsws

if [ -d "/home/olsuser/lsws" ]
then
	echo '[INFO] Persistant volume mounted'
	fileCount=$(find /home/olsuser/lsws -type f | wc -l)
	if [ $fileCount -gt 5 ]
         then
         echo "ols files exists"
	else
		echo "[INFO] Copying app files to /home/olsuser/lsws";
		cp -rp /home/olsuser/tmp/lsws /home/olsuser
		echo "[INFO] App files copied to /home/olsuser/lsws";
	fi
else
	echo '[ERROR] /home/olsuser/lsws doesnt exists'
fi

/home/olsuser/lsws/bin/lswsctrl start
$@
while true; do
	if ! /home/olsuser/lsws/bin/lswsctrl status | grep 'litespeed is running with PID *' > /dev/null; then
		break
	fi
	sleep 60
done

