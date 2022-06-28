#!/bin/bash

# restore the feeder-id from non-volatile storage
[ -e /dockerShare/piaware.conf ] && cp /dockerShare/piaware.conf /etc/piaware.conf

mkdir /run/dump1090-fa
/usr/share/dump1090-fa/start-dump1090-fa --write-json /run/dump1090-fa &
service piaware start
service lighttpd start

#Extra
exec /bin/bash
