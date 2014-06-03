#!/bin/bash

# Small script to get one specific PKGBUILD
# with the help of the Arch subversion servers.
# Useful if ABS got no update, or a [testing] PKGBuild is required.

if [ $# -ne 2 ] ; then
	echo "Usage: $0 <repo> <package>"
	exit $E_NO_ARGS
fi

PAKNAME=$2
REPO=$1

echo "Checking out server"
if [ "$REPO" == "core" ] || [ "$REPO" == "extra" ] ; then
	svn checkout --depth=empty svn://svn.archlinux.org/packages
	cd packages
fi

if [ "$REPO" == "com" ] || [ "$REPO" == "multi" ] ; then
	svn checkout --depth=empty svn://svn.archlinux.org/community
	cd community
fi
echo "...done"

echo "Get package"
svn update $PAKNAME
echo "...done"

echo -e "\nMove folder"
mv -v "$PAKNAME" "$HOME/Builds/ABS/_New/"
cd ..
if [ "$REPO" == "core" ] || [ "$REPO" == "extra" ] ; then
	rm -r packages
fi
if [ "$REPO" == "com" ] || [ "$REPO" == "multi" ] ; then
	rm -r community
fi
echo "...done"
