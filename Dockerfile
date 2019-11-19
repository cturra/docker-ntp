FROM alpine:latest

# install openntp
RUN apk add --no-cache openntpd

# script to configure/startup ntpd
COPY assets/startup.sh /opt/startup.sh

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD ntpctl -s status || exit 1

# start ntpd in the foreground
ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
