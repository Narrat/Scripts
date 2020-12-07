#!/bin/sh
#
# Script for Thunar Custom Actions
# Click on file, select Hashsum (if that's the TCA name)
# get a dmenu where you choose the hash algo
# result via dunst (or zenity, or dzen2)

if [ $# -ne 1 ] ; then
    echo "Usage: $0 File"
    exit $E_NO_ARGS
fi

function createmessage {
    # ${var,} = to upper; ${var,,} = to lower
    ${1,,}sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}'
}

INPUT=$1

#DMENU='dmenu -i -b'
#DMENU='rofi -hide-scrollbar -columns 6 -dmenu -l 1 -i -p HASH:'
DMENU='bemenu -i -p HASH:'

menitem=$(echo -e "Blake2\nMD5\nSHA1\nSHA224\nSHA256\nSHA384\nSHA512" | $DMENU)

case "$menitem" in
  MD5|SHA*)
    notify-send "${menitem}: $(createmessage ${menitem})" ;;
  Blake2)
    notify-send "${menitem}: $(createmessage b2)" ;;
esac
