FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update      \
 && apt-get -y --no-install-recommends install ntp

# tweak some permissions to run as root
RUN chgrp root /var/lib/ntp \
 && chmod g+w  /var/lib/ntp

# ntp port
EXPOSE 123/udp

# start ntpd in the foreground
ENTRYPOINT [ "/usr/sbin/ntpd", "-g", "-n" ]
