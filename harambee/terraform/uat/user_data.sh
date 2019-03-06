#!/bin/bash

set -e
set -x

DEST=/data


DEVICE=$(sudo lsblk -n | awk '$NF != "/" {print $1}' | grep -v $(blkid | awk 'match($0, /\/dev\/([^:]+)[0-9]+/, arr) { print arr [1]}'))
DEVICE=/dev/$DEVICE
FS_TYPE=$(sudo file -s $DEVICE | awk '{print $2}')

devpath=$(sudo readlink -f $DEVICE)

if [[ $(sudo file -s $devpath) != *ext4* && -b $devpath ]]; then
  # Create filesystem
  sudo mkfs -t ext4 $devpath
fi

sudo mkdir -p $DEST

# add to fstab if not present
if ! egrep "^${devpath}" /etc/fstab; then
  echo "$devpath $DEST ext4 defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2" | sudo tee -a /etc/fstab > /dev/null
fi

sudo mount $DEST

sudo apt-get install -y python python-dev
