#!/bin/sh

# For testing purposes only. There exist better alternatives

sudo modprobe zram
sudo zramctl -f --size 1024m
sudo mkswap /dev/zram0
sudo swapon /dev/zram0 -p 100