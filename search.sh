#!/usr/bin/sh
#
# Search - Search after names via find
#
# * Specify search path?
# * Sane way to use find? Instead of locate

DYNMEN="rofi -dmenu -l7"

# Get name to search for
input="$(xsel -o | $DYNMEN -p "Search:")"

# Print search result
if [ "$input" != '' ]
then
    result="$(echo "$input" | find . -name "*$input*" | $DYNMEN -p "Result:" )"
    if [ "$result" != '' ]
    then
        xdg-open "$result"
    fi
fi
