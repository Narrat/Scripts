#!/bin/bash

# Small script to get one specific PKGBUILD
# with the help of the Arch subversion servers.
# Useful if ABS got no update, or a [testing] PKGBuild is required.

if [ $# -ne 2 ] ; then
	echo "Usage: $0 <server> <package>"
    echo "Server:"
    echo "main (Core, Extra, Testing)"
    echo "com (Community, Multilib)"
	exit $E_NO_ARGS
fi

PAKNAME=$2
REPO=$1

echo "Checking out server"
if [ "$REPO" == "main" ] ; then
    # SVN-Server for [Core], [Extra] and [Testing]
	svn checkout --depth=empty svn://svn.archlinux.org/packages
	cd packages
fi

if [ "$REPO" == "com" ] ; then
    # SVN-Server for [Community], [Multilib]
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
if [ "$REPO" == "main" ] ; then
	rm -r packages
else
	rm -r community
fi
echo "...done"
