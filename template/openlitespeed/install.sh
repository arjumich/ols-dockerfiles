#!/bin/sh

SERVERROOT=/usr/local/lsws
OPENLSWS_USER=nobody
OPENLSWS_GROUP=nobody
OPENLSWS_ADMIN=admin
OPENLSWS_PASSWORD=
OPENLSWS_EMAIL=root@localhost
OPENLSWS_ADMINSSL=yes
OPENLSWS_ADMINPORT=7080
USE_LSPHP7=yes
DEFAULT_TMP_DIR=/tmp/lshttpd
PID_FILE=/tmp/lshttpd/lshttpd.pid
OPENLSWS_EXAMPLEPORT=8088
CONFFILE=./ols.conf
    
#script start here
cd `dirname "$0"`

if [ -f $CONFFILE ] ; then
    . $CONFFILE
fi

mkdir -p $SERVERROOT >/dev/null 2>&1


PASSWDFILEEXIST=no

if [ -f ${SERVERROOT}/admin/conf/htpasswd ] ; then
    PASSWDFILEEXIST=yes
else
    PASSWDFILEEXIST=no
    #Generate the random PASSWORD if not set
    if [ "x$OPENLSWS_PASSWORD" = "x" ] ; then
        dd if=/dev/urandom bs=8 count=1 of=/tmp/randpasswdtmpfile >/dev/null 2>&1
        TEMPRANDSTR=`cat /tmp/randpasswdtmpfile`
        rm /tmp/randpasswdtmpfile
        DATES=`date`
        TEMPRANDSTR=`echo "${TEMPRANDSTR}${RANDOM}${DATES}" |  md5sum | base64 | head -c 8`
        
        OPENLSWS_PASSWORD=${TEMPRANDSTR}
        echo OPENLSWS_PASSWORD=${OPENLSWS_PASSWORD} >> ./ols.conf
    fi

    echo "WebAdmin user/password is admin/${OPENLSWS_PASSWORD}" > $SERVERROOT/adminpasswd
    chmod 600 $SERVERROOT/adminpasswd
fi

#Change to nogroup for debain/ubuntu
if [ -f /etc/debian_version ] ; then
    if [ "${OPENLSWS_GROUP}" = "nobody" ] ; then
        OPENLSWS_GROUP=nogroup
    fi
fi 

ISRUNNING=no

if [ -f $SERVERROOT/bin/openlitespeed ] ; then 
    echo Openlitespeed web server exists, will upgrade.
    
    $SERVERROOT/bin/lswsctrl status | grep ERROR
    if [ $? != 0 ]; then
        ISRUNNING=yes
    fi
fi

./_in.sh "$SERVERROOT" "$OPENLSWS_USER" "${OPENLSWS_GROUP}" "$OPENLSWS_ADMIN" "${OPENLSWS_PASSWORD}" "$OPENLSWS_EMAIL" "$OPENLSWS_ADMINSSL" "$OPENLSWS_ADMINPORT" "$USE_LSPHP7" "$DEFAULT_TMP_DIR" "$PID_FILE" "$OPENLSWS_EXAMPLEPORT" no

cp -f modules/*.so $SERVERROOT/modules/
cp -f bin/openlitespeed $SERVERROOT/bin/


if [ "${PASSWDFILEEXIST}" = "no" ] ; then
    echo -e "\e[31mYour webAdmin password is ${OPENLSWS_PASSWORD}, written to file $SERVERROOT/adminpasswd.\e[39m"
else
    echo -e "\e[31mYour webAdmin password not changed.\e[39m"
fi

if [ "$ISRUNNING" = "yes" ] ; then
    $SERVERROOT/bin/lswsctrl start
fi

