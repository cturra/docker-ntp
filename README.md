About this container
---
[![Docker Build Status](https://img.shields.io/docker/build/cturra/ntp.svg)](https://hub.docker.com/r/cturra/ntp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/cturra/ntp.svg)](https://hub.docker.com/r/cturra/ntp/)
[![Apache licensed](https://img.shields.io/badge/license-Apache-blue.svg)](https://raw.githubusercontent.com/cturra/docker-ntp/master/LICENSE)

This container runs [OpenNTPD](http://www.openntpd.org/index.html) on [Alpine Linux](https://alpinelinux.org/). More about NTP can be found at:

  http://www.ntp.org


Running from Docker Hub
---
Pull and run -- it's this simple.

```
# pull from docker hub
$> docker pull cturra/ntp

# run ntp
$> docker run --name=ntp             \
              --restart=always       \
              --detach=true          \
              --publish=123:123/udp  \
              --cap-add=SYS_NICE     \
              --cap-add=SYS_RESOURCE \
              --cap-add=SYS_TIME     \
              cturra/ntp
```


Building and Running with Docker Compose
---
Using the docker-compose.yml file included in this git repo, you can build the container yourself (should you choose to).
*Note: this docker-compose files uses the `3.4` compose format, which requires Docker Engine release 17.09.0+

```
# build ntp
$> docker-compose build ntp

# run ntp
$> docker-compose up -d ntp

# (optional) check the ntp logs
$> docker-compose logs ntp
```


Building and Running with Docker Engine
---
Using the vars file in this git repo, you can update any of the variables to reflect your
environment. Once updated, simply execute the build then run scripts.

```
# build ntp
$> ./build.sh

# run ntp
$> ./run.sh
```


Test NTP
---
From any machine that has `ntpdate` you can query your new NTP container with the follow
command:

```
$> ntpdate -q <DOCKER_HOST_IP>
```


Here is a sample output from my environment:

```
$> ntpdate -q 10.13.13.9
server 10.13.13.9, stratum 3, offset 0.010089, delay 0.02585
17 Sep 15:20:52 ntpdate[14186]: adjust time server 10.13.13.9 offset 0.010089 sec
```

If you see a message, like the following, it's likely the clock is not yet synchronized.
```
$> ntpdate -q 10.13.13.9
server 10.13.13.9, stratum 16, offset 0.005689, delay 0.02837
11 Dec 09:47:53 ntpdate[26030]: no server suitable for synchronization found
```

To see details on the ntpd status, you can check with the below command on your
docker host:
```
$> docker exec ntp ntpctl -s status
4/4 peers valid, clock synced, stratum 2
```
