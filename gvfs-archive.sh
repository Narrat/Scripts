#!/bin/bash
# Needs:
# URI::Escape from Perl
# or
# jq

# ToDo:
# * Cover unmount
# * Little help
# * rename

# https://andy.wordpress.com/2008/09/17/urlencode-in-bash-with-perl/
# https://gitlab.gnome.org/GNOME/glib/-/issues/1456

if [ ! -f "$1" ]
then
    echo "$1 is not a valid file" >&2
    exit 1
fi

gio mount "archive://$( readlink -f "$1" | perl -MURI::Escape -lne 'print uri_escape($_)')"
#gio mount "archive://$( readlink -f "$1" | jq -s -R -r @uri)"
