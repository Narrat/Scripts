#!/bin/bash

# Kleines Skript um ein bestimmtes PKGBuild per Subversion herunterzuladen, falls abs an sich noch nicht aktuell genug ist


if [ $# -ne 2 ] ; then
	echo "Usage: $0 Repo Paketname"
	exit $E_NO_ARGS
fi

PAKNAME=$2
REPO=$1

echo "Checke Server aus..."
if [ "$REPO" == "core" ] || [ "$REPO" == "extra" ] ; then
	svn checkout --depth=empty svn://svn.archlinux.org/packages
	cd packages
fi

if [ "$REPO" == "com" ] || [ "$REPO" == "multi" ] ; then
	svn checkout --depth=empty svn://svn.archlinux.org/community
	cd community
fi
echo "...done"

echo "Hole Paket..."
svn update $PAKNAME
echo "...done"

echo -e "\nVerschiebe Ordner"
mv -v "$PAKNAME" "$HOME/Builds/ABS/_New/"
cd ..
if [ "$REPO" == "core" ] || [ "$REPO" == "extra" ] ; then
	rm -r packages
fi
if [ "$REPO" == "com" ] || [ "$REPO" == "multi" ] ; then
	rm -r community
fi
echo "...done"
