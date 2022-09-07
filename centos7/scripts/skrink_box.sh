#!/usr/bin/env bash

# Shrink root file system
count="$(df --sync -kP / | tail -n1 | awk -F ' ' '{ print $4 }')" &&
count="$(($count -1 ))" &&
dd if=/dev/zero of=/tmp/whitespace bs=1024 count="$count" ||
echo "Zeroed root filesystem" &&
rm -vf /tmp/whitespace

# Shrink boot partition
count="$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{ print $4 }')" &&
count="$(($count -1 ))" &&
dd if=/dev/zero of=/tmp/whitespace bs=1024 count="$count" ||
echo "Zeroed boot partition" &&
rm -vf /tmp/whitespace

# Shrink swap space
swapuuid="$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)" &&
swappart="$(readlink -f "/dev/disk/by-uuid/${swapuuid}")" &&
/sbin/swapoff "$swappart" &&
dd if=/dev/zero of="$swappart" bs=1M ||
echo "Zeroed swap space" &&
/sbin/mkswap -U "$swapuuid" "$swappart"

# Skrink root partition and persist disks
dd if=/dev/zero of=/whitespace bs=1M ||
echo "Zeroed disk" &&
rm -vf /whitespace &&
sync
