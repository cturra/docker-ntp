FROM alpine:latest

ARG BUILD_DATE

# first, a bit about this container
LABEL build_info="cturra/docker-ntp build-date:- ${BUILD_DATE}"
LABEL maintainer="Chris Turra <cturra@gmail.com>"
LABEL documentation="https://github.com/cturra/docker-ntp"

# install chrony
RUN apk add --no-cache chrony

# script to configure/startup chrony (ntp)
COPY assets/startup.sh /opt/startup.sh

# ntp port
EXPOSE 123/udp

# let docker know how to test container health
HEALTHCHECK CMD chronyc tracking || exit 1

# start chronyd in the foreground
ENTRYPOINT [ "/bin/sh", "/opt/startup.sh" ]
