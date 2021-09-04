## About this container

[![Docker Pulls](https://img.shields.io/docker/pulls/cturra/ntp.svg?logo=docker&label=pulls&style=for-the-badge&color=0099ff&logoColor=ffffff)](https://hub.docker.com/r/cturra/ntp/)
[![Docker Stars](https://img.shields.io/docker/stars/cturra/ntp.svg?logo=docker&label=stars&style=for-the-badge&color=0099ff&logoColor=ffffff)](https://hub.docker.com/r/cturra/ntp/)
[![GitHub Stars](https://img.shields.io/github/stars/cturra/docker-ntp.svg?logo=github&label=stars&style=for-the-badge&color=0099ff&logoColor=ffffff)](https://github.com/cturra/docker-ntp)
[![Apache licensed](https://img.shields.io/badge/license-Apache-blue.svg?logo=apache&style=for-the-badge&color=0099ff&logoColor=ffffff)](https://raw.githubusercontent.com/cturra/docker-ntp/master/LICENSE)

This container runs [chrony](https://chrony.tuxfamily.org/) on [Alpine Linux](https://alpinelinux.org/).

[chrony](https://chrony.tuxfamily.org) is a versatile implementation of the Network Time Protocol (NTP). It can synchronise the system clock with NTP servers, reference clocks (e.g. GPS receiver), and manual input using wristwatch and keyboard. It can also operate as an NTPv4 (RFC 5905) server and peer to provide a time service to other computers in the network.


## Supported Architectures

Architectures officially supported by this Docker container. Simply pulling this container from [Docker Hub](https://hub.docker.com/r/cturra/ntp) should retrieve the correct image for your architecture.

![Linux x86-64](https://img.shields.io/badge/linux/amd64-green?style=flat-square)
![ARMv8 64-bit](https://img.shields.io/badge/linux/arm64-green?style=flat-square)
![IBM POWER8](https://img.shields.io/badge/linux/ppc64le-green?style=flat-square)
![IBM Z Systems](https://img.shields.io/badge/linux/s390x-green?style=flat-square)
![Linux x86/i686](https://img.shields.io/badge/linux/386-green?style=flat-squareg)
![ARMv7 32-bit](https://img.shields.io/badge/linux/arm/v7-green?style=flat-square)
![ARMv6 32-bit](https://img.shields.io/badge/linux/arm/v6-green?style=flat-square)


## How to Run this container

### With the Docker CLI

Pull and run -- it's this simple.

```
# pull from docker hub
$> docker pull cturra/ntp

# run ntp
$> docker run --name=ntp            \
              --restart=always      \
              --detach              \
              --publish=123:123/udp \
              cturra/ntp

# OR run ntp with higher security (default behaviour of run.sh and docker-compose).
$> docker run --name=ntp                           \
              --restart=always                     \
              --detach                             \
              --publish=123:123/udp                \
              --read-only                          \
              --tmpfs=/etc/chrony:rw,mode=1750     \
              --tmpfs=/run/chrony:rw,mode=1750     \
              --tmpfs=/var/lib/chrony:rw,mode=1750 \
              cturra/ntp
```


### With Docker Compose

Using the docker-compose.yml file included in this git repo, you can build the container yourself (should you choose to).
*Note: this docker-compose files uses the `3.4` compose format, which requires Docker Engine release 17.09.0+

```
# pull from docker hub
$> docker pull cturra/ntp

# build ntp
$> docker-compose build ntp

# run ntp
$> docker-compose up -d ntp

# (optional) check the ntp logs
$> docker-compose logs ntp
```


### From a CLI

Using the vars file in this git repo, you can update any of the variables to reflect your
environment. Once updated, simply execute the build then run scripts.

```
# build ntp
$> ./build.sh

# run ntp
$> ./run.sh
```


## Configure NTP Servers

By default, this container uses CloudFlare's time server (time.cloudflare.com). If you'd
like to use one or more different NTP server(s), you can pass this container an `NTP_SERVERS`
environment variable. This can be done by updating the [vars](vars), [docker-compose.yml](docker-compose.yml)
files or manually passing `--env=NTP_SERVERS="..."` to `docker run`.

Below are some examples of how to configure common NTP Servers.

Do note, to configure more than one server, you must use a comma delimited list WITHOUT spaces.

```
# (default) cloudflare
NTP_SERVERS="time.cloudflare.com"

# google
NTP_SERVERS="time1.google.com,time2.google.com,time3.google.com,time4.google.com"

# alibaba
NTP_SERVERS="ntp1.aliyun.com,ntp2.aliyun.com,ntp3.aliyun.com,ntp4.aliyun.com"
```

If you're interested in a public list of stratum 1 servers, you can have a look at the following list.
Do make sure to verify the ntp server is active as this list does appaer to have some no longer active
servers.

 * https://www.advtimesync.com/docs/manual/stratum1.html


## Logging

By default, this project logs informational messages to stdout, which can be helpful when running the
ntp service. If you'd like to change the level of log verbosity, pass the `LOG_LEVEL` environment
variable to the container, specifying the level (`#`) when you first start it. This option matches
the chrony `-L` option, which support the following levels can to specified: 0 (informational), 1
(warning), 2 (non-fatal error), and 3 (fatal error).

Feel free to check out the project documentation for more information at:

 * https://chrony.tuxfamily.org/doc/4.1/chronyd.html


## Testing your NTP Container

From any machine that has `ntpdate` you can query your new NTP container with the follow
command:

```
$> ntpdate -q <DOCKER_HOST_IP>
```


Here is a sample output from my environment:

```
$> ntpdate -q 10.13.13.9
server 10.13.1.109, stratum 4, offset 0.000642, delay 0.02805
14 Mar 19:21:29 ntpdate[26834]: adjust time server 10.13.13.109 offset 0.000642 sec
```


If you see a message, like the following, it's likely the clock is not yet synchronized.
You should see this go away if you wait a bit longer and query again.
```
$> ntpdate -q 10.13.13.9
server 10.13.13.9, stratum 16, offset 0.005689, delay 0.02837
11 Dec 09:47:53 ntpdate[26030]: no server suitable for synchronization found
```

To see details on the ntp status of your container, you can check with the command below
on your docker host:
```
$> docker exec ntp chronyc tracking
Reference ID    : D8EF2300 (time1.google.com)
Stratum         : 2
Ref time (UTC)  : Sun Mar 15 04:33:30 2020
System time     : 0.000054161 seconds slow of NTP time
Last offset     : -0.000015060 seconds
RMS offset      : 0.000206534 seconds
Frequency       : 5.626 ppm fast
Residual freq   : -0.001 ppm
Skew            : 0.118 ppm
Root delay      : 0.022015510 seconds
Root dispersion : 0.001476757 seconds
Update interval : 1025.2 seconds
Leap status     : Normal
```


Here is how you can see a peer list to verify the state of each ntp source configured:
```
$> docker exec ntp chronyc sources
210 Number of sources = 2
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^+ time.cloudflare.com           3  10   377   404   -623us[ -623us] +/-   24ms
^* time1.google.com              1  10   377  1023   +259us[ +244us] +/-   11ms
```


Finally, if you'd like to see statistics about the collected measurements of each ntp
source configured:
```
$> docker exec ntp chronyc sourcestats
210 Number of sources = 2
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
time.cloudflare.com        35  18  139m     +0.014      0.141   -662us   530us
time1.google.com           33  13  128m     -0.007      0.138   +318us   460us
```


Are you seeing messages like these and wondering what is going on?
```
$ docker logs -f ntps
[...]
2021-05-25T18:41:40Z System clock wrong by -2.535004 seconds
2021-05-25T18:41:40Z Could not step system clock
2021-05-25T18:42:47Z System clock wrong by -2.541034 seconds
2021-05-25T18:42:47Z Could not step system clock
```

Good question! Since `chronyd` is running with the `-x` flag, it will not try to control
the system (container host) clock. This of course is necessary because the process does not
have priviledge (for good reason) to modify the clock on the system.

Like any host on your network, simply use your preferred ntp client to pull the time from
the running ntp container on your container host.

---
<a href="https://www.buymeacoffee.com/cturra" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-yellow.png" alt="Buy Me A Coffee" height="41" width="174"></a>
