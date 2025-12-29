# scripts
For now just a script to rotate and manage zfs snapshots (on FreeBSD)
can be used with cron to manage a tiered structure, e.g. some hourly, daily, monthly etc sapshots.

example:
```
0 3 * * Sun /root/bin/rotate_snapshots.sh zroot/data 4 weekly
0 3 1 * * /root/bin/rotate_snapshots.sh zroot/data 3 monthly weekly
```

