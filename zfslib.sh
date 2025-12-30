zfs_oldestsnap()
{
  # $1 dataset
  # $2 prefix
  zfs list -Ht snap "$1" -o name|grep "@${2}"| head -n1
}

zfs_snaprotate()
{
  [ "$1" ] || {
    echo "usage: zfs_snaprotate dataset [maxsnapshots] [prefix] [otherprefix]"
      echo "   - default number of kept snaps is 4"
      echo "   - default prefix is \"snaprotate\""
      echo "   - otherprefix: adopt oldest snapshot from that prefix instead of snapping a new one"
      echo "     idea is to promote e.g. the oldest hourly snap to be the youngest daily one."
      echo ""
      echo "   Prints the freshly handled/created snapshot name to stdout."
      return 1;
    }

  dataset=$1
  nmaxdatasets="${2:-"4"}"
  tag_prefix="${3:-"snaprotate"}"
  spill_from="$4"

  zfs_snapshot_tag=$(date "+${tag_prefix}_%Y_%m_%d_%H:%M:%S")

  oldestsnap=""
  if [ -n "$spill_from" ]; then
    oldestsnap=$(zfs_oldestsnap "$dataset" "$spill_from")
  fi
  if [ -n "$oldestsnap" ]; then
    hijackedsnap=$(echo "$oldestsnap" | sed "s/@${spill_from}/@${tag_prefix}/")
    zfs rename "$oldestsnap" "$hijackedsnap"
  else
    zfs snap "$dataset@$zfs_snapshot_tag"
  fi
  echo "$dataset@$zfs_snapshot_tag"

  #reduce the number of existing snapshots to the desired one (zero is also an option)
  ndatasets=$(zfs list -Ht snap "$dataset" | grep "@${tag_prefix}" | wc -l)
  while [ "$ndatasets" -gt "$nmaxdatasets" ]; do
    oldestsnap=$(zfs_oldestsnap "$dataset" "$tag_prefix")
    zfs destroy "$oldestsnap"

    #prevent an endless loop if not exactly one dataset gets destroyed
    #zfs docs say nothing about the return code of zfs-destroy so check directly
    _ndatasets=$(zfs list -Ht snap "$dataset" | grep "@${tag_prefix}" |wc -l)
    if [ $(($ndatasets - $_ndatasets)) -ne 1 ]
    then
      break
    fi

    ndatasets=$_ndatasets
  done
}
