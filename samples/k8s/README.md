# K8S Restricted

Under fully restricted there is a caveat:

```log
2024-12-28T02:36:44Z Wrong permissions on /run/chrony
2024-12-28T02:36:44Z Disabled command socket /run/chrony/chronyd.sock
```

To use chronyc, instead use:

```bash
/usr/bin/chronyc -h 127.0.0.1 -p 10323 sources
```