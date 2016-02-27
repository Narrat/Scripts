#!/usr/bin/sh
#
# Search - Search after names via find
#

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
search_mode="-name"
mode_input=()

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
    items=("Search for name (case sensitive)" "Search for name (case insensitive)")
    menitem=$(echo -e "${items[0]}\n${items[1]}" | $DYNMEN -p "What search type?:")

    case "$menitem" in
      ${items[0]})  search_mode="-iname" ;;
      ${items[1]})  search_mode="-iname" ;;
    esac

    first_window
}

search_reset () {
    notify-send "Wanted a new search"

    first_window
}

#=====
# Get name to search for
first_window

# Globbing chars will be expanded. So crude hack for now
mode_input+=(${search_mode} "*${input}*")
#echo ${mode_input[@]}

# Print search result
# Calling the array at whole will also expand the globbing chars
#result=$(find ${path} ${mode_input[@]} | $DYNMEN -p "Result:")
result=$(find ${path} ${mode_input[0]} "${mode_input[1]}" | $DYNMEN -p "Result:")
if [ "$result" != '' ]
then
    $OPEN_RESULT "$result"
fi
