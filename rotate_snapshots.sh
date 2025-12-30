#!/bin/sh

. $(dirname $0)/zfslib.sh

zfs_snaprotate "$1" "$2" "$3" "$4"

