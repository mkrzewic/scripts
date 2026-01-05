# scripts
## rotate_snapshots.sh
A script to rotate and manage zfs snapshots (on FreeBSD)
Can be used with cron to manage a tiered structure, e.g. some hourly, daily, monthly etc sapshots.
Needs no root priviledges provided the user has permissions to make snapshots.

example:
```
0 3 * * Sun rotate_snapshots.sh zroot/data 4 weekly
0 3 1 * * rotate_snapshots.sh zroot/data 12 monthly weekly
0 3 1 1 * rotate_snapshots.sh zroot/data 3 yearly monthly
```

