#!/bin/sh

# For testing purposes only. There exist better alternatives

# check if root
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script. Aborting...";
   exit 1;
fi

modprobe zram
zramctl -f --size 1024m
mkswap /dev/zram0
swapon /dev/zram0 -p 100
