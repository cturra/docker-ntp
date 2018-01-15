FROM alpine:latest

RUN apk update       \
 && apk add openntpd \
 && rm -rf /var/cache/apk/*


#Make it easier to mount a different config file on the fly
RUN mkdir /data && rm /etc/ntpd.conf && ln -s /data/ntpd.conf /etc/ntpd.conf 

# use custom ntpd config file
COPY assets/ntpd.conf /data/ntpd.conf

# ntp port
EXPOSE 123/udp

# start ntpd in the foreground
ENTRYPOINT [ "/usr/sbin/ntpd", "-v", "-d", "-s" ]
