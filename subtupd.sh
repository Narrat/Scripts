#!/usr/bin/sh
#
# SUBTreeUPDate
#
# Avoid this somewhat lengthy command

if [ $# -ne 1 ] ; then
    echo "Usage: $0 SubTreeFolder"
    exit $E_NO_ARGS
fi

INPUT=$1
WDIR="$HOME/Builds/Maint/PKGBuilds"

cd $WDIR
#git subtree add --prefix="$INPUT" "${INPUT}-aur" master
git subtree pull --prefix="$INPUT" "${INPUT}-aur" master