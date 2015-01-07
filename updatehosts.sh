#!/bin/bash
#
# Updater for Ad-block with hosts file
# You will probably need root or su rights to access /etc/hosts
#
# Deps:
# curl (or wget or aria2)
#

HFSERVER="http://someonewhocares.org/hosts/"
HFILE="hosts"
BACKFILE="/etc/hosts.back"

echo "-------------------------------------------------------------"
echo "This script will update your Hosts file to the latest version"
echo "Your original Hosts file will be renamed to $BACKFILE"
echo -e "-------------------------------------------------------------\n"

if [ ! -f "$BACKFILE" ] ; then
    echo "Backing up your hosts file.."
    cp -v /etc/$HFILE $BACKFILE
fi

echo -e "Retrieving $HFILE from ${HFSERVER}\n"
# DL-Agents
curl -o /tmp/$HFILE $HFSERVER/$HFILE
#wget -O /tmp/$HFILE $HFSERVER/$HFILE
#aria2c -o /tmp/$HFILE $HFSERVER/$HFILE

if [ 'grep -c "banner" /tmp/hosts' ];then
    echo "Downloaded and unpacked $HFILE OK"
    echo "Appending host list to original content"
    cat $BACKFILE >/etc/$HFILE
    # to make sure the original file ends in a new-line
    # so that 2 entries don't end up on the same line,
    #either causing unexpected behavior or not working at all
    echo "" >>/etc/hosts
    cat /tmp/$HFILE >>/etc/$HFILE
    rm -fv /tmp/$HFILE
    echo -e "Update process complete\n"
    echo "As a side-effect of this script, any changes you wish to make"
    echo "persistent in the hosts file should be made to $BACKFILE"
    echo "because /etc/hosts will be respawned from that file and the "
    echo "newlist from the server each time this script runs."
    exit
else
    echo "Update failed"
fi
