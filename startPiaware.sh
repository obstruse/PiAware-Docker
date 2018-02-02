#!/bin/bash

source /etc/default/dump1090-fa
if [ -e /var/cache/piaware/location.env ] ; then
	source /var/cache/piaware/location.env
fi

/usr/bin/dump1090-fa $RECEIVER_OPTIONS $DECODER_OPTIONS $NET_OPTIONS $JSON_OPTIONS $PIAWARE_DUMP1090_LOCATION_OPTIONS  --write-json /run/dump1090-fa --quiet &
/usr/bin/piaware -p /run/piaware/piaware.pid -plainlog -statusfile /run/piaware/status.json & 
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf  &

#Extra
exec /bin/bash
