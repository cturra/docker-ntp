#!/bin/sh

while true; do { echo -e 'HTTP/1.1 200 OK\r\n'; echo 'OK'; } | nc -l -p 11999; done &

/opt/ntp_startup.sh
