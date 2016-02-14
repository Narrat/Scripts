#!/usr/bin/sh
#
# Search - Search after names via find
#
# * Specify search path?
# * Sane way to use find? Instead of locate

DYNMEN="rofi -dmenu -l7"
SEARCH_START_DIR=$(pwd)
SEARCH_BASE_DIR=$HOME
OPEN_RESULT=xdg-open

searchpath="Alt+F1"
searchtype="Alt+F2"
searchreset="Alt+F3"

clipinput="$(xsel -o)"
input=""
path="${SEARCH_START_DIR}"

# Some functions
first_window () {
    input="$(echo ${clipinput} | $DYNMEN -mesg "Searchpath Searchtype New Search" -kb-custom-1 ${searchpath} -kb-custom-2 ${searchtype} -kb-custom-3 ${searchreset} -p "Search:")"

    val=$?

    if [[ $val -eq 1 ]]; then
        exit
    elif [[ $val -eq 10 ]]; then
        search_path
    elif [[ $val -eq 11 ]]; then
        search_type
    elif [[ $val -eq 12 ]]; then
        search_reset
    fi
}

search_path () {
    # file browser like behaviour?
    # or just typing?
    # get list of first layer of folders in $HOME?
    if [ "${path}" == "${SEARCH_BASE_DIR}" ]; then
        cpath="${path}"
    else
        cpath="${path}\n${SEARCH_BASE_DIR}"
    fi
    path="$(echo -e $cpath | $DYNMEN -p "Enter path:")"

    first_window
}

search_type () {
    notify-send "Wanted to change the search type"

    first_window
}

search_reset () {
    notify-send "Wanted a new search"

    first_window
}

#=====
# Get name to search for
first_window

# Print search result
if [ "$input" != '' ]
then
    result="$(echo "$input" | find ${path} -name "*$input*" | $DYNMEN -p "Result:" )"
    if [ "$result" != '' ]
    then
        $OPEN_RESULT "$result"
    fi
fi
