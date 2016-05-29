#!/bin/bash
# Found on http://ubuntuforums.org/showthread.php?t=1207096&s=504364991bb1155358f39d655cc8e88c

if [ ! -f "$1" ]
then
    echo "$1 is not a valid file" >&2
    exit 1
fi

gvfs-mount "archive://$( ( echo -n 'file://' ; readlink -f "$1" ; ) | perl -MURI::Escape -lne 'print uri_escape($_)')"