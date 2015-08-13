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

INPUT=$1

DMENU='dmenu -i -b'
menitem=$(echo -e "MD5\nSHA1\nSHA224\nSHA256\nSHA384\nSHA512" | $DMENU)

case "$menitem" in
  MD5)      notify-send "MD5: $(md5sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}')" ;;
  SHA1)     notify-send "SHA1: $(sha1sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}')" ;;
  SHA224)   notify-send "SHA224: $(sha224sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}')" ;;
  SHA256)   notify-send "SHA256: $(sha256sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}')" ;;
  SHA384)   notify-send "SHA384: $(sha384sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}')" ;;
  SHA512)   notify-send "SHA512: $(sha512sum "${INPUT}" | awk '{out=$2; for(i=3;i<=NF;i++){out=out" "$i}; print out}{print $1}')" ;;
esac
