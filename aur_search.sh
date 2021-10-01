#!/bin/sh
#
# Search the AUR via the provided file from
# https://aur.archlinux.org/packages.gz
# and fzf/skim

if [ ! -f "/tmp/packages.gz" ]
then
    curl https://aur.archlinux.org/packages.gz -o /tmp/packages.gz
fi

zcat "/tmp/packages.gz" | sk -m | xargs auracle info
