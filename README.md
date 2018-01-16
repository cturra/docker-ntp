About this container
---
[![Docker Build Status](https://img.shields.io/docker/build/cturra/ntp.svg)](https://hub.docker.com/r/cturra/dropbox/)
[![Docker Pulls](https://img.shields.io/docker/pulls/cturra/ntp.svg)](https://hub.docker.com/r/cturra/dropbox/)
[![Apache licensed](https://img.shields.io/badge/license-Apache-blue.svg)](https://raw.githubusercontent.com/cturra/docker-dropbox/badges/LICENSE)

This container runs [OpenNTPD](http://www.openntpd.org/index.html) on [Alpine Linux](https://alpinelinux.org/). More about NTP can be found at:

  http://www.ntp.org

Using Docker-compose
---

Download the docker-compose.yml from this repository and place it in a clean directory.


Running Docker-ntp as a service in the background:

$> docker-compose up -d

Manually pull the image from Docker hub (for example, to update to a newer version):

$> docker-compose pull

Build the image locally (useful to test changes to the Dockerfile):

$> docker-compose build


Check and edit the content of docker-compose.yml to load your own ntpd.conf config file. 



Running manually without Docker-compose
---
Pull and run -- it's this simple.

```
# Pull from docker hub
$> docker pull nicoinn/docker-ntp

# Run docker-ntp
$> docker run --name=ntp             \
              --restart=always       \
              --detach=true          \
              --publish=123:123/udp  \
              --cap-add=SYS_RESOURCE \
              --cap-add=SYS_TIME     \
              nicoinn/docker-ntp
```

# Load your own NTP config file into the container

Add `-v /path/to/folder/containing/my_config_file:/data`

NB: This way, one can save the NTP drift file accross container restart by adding 

```driftfile /data/drift```

into your ntpd.conf file. 


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
$> docker exec docker-ntp ntpctl -s status
4/4 peers valid, clock synced, stratum 2
```
