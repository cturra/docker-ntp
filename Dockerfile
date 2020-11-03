FROM alpine:latest

# install chrony
RUN apk add --no-cache chrony && \
    rm /etc/chrony/chrony.conf

# script to configure/startup chrony (ntp)
COPY assets/startup.sh /opt/startup.sh

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD chronyc tracking || exit 1

VOLUME /etc/chrony /var/lib/chrony /var/run/chrony

# start chronyd in the foreground
ENTRYPOINT [ "/opt/startup.sh" ]
