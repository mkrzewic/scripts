#!/bin/sh

. /root/bin/zfslib.sh

zfs_snaprotate "$1" "$2" "$3" "$4"

