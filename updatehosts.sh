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
echo "-------------------------------------------------------------"
echo ""

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

#__________
#On 2013-03-31 at 10:29 +0200, vermaden wrote:
#> Hi all,I use 'static' 127.0.0.1 entries in /etc/hosts to block various
#> things, like described here for
#> example:http://someonewhocares.org/hosts/ Of course ZSH always tries
#> to 'complete' the ssh/scp and always goes thru about 100 000 entries
#> in my /etc/hosts file while the 'real' ones are about 100 maybe at
#> most. My question is: Is there a way to 'tell' ZSH to NOT complete
#> entries beginning with 127.0.0.1 from the /etc/hosts file?
#> Regards,vermaden 
#
#Are you aware that the contents of /etc/hosts get loaded into _every_
#process doing hostname resolution?  And the file isn't mmap'd in and so
#shared, but is instead _read_ into each process, so is not shared
#memory?
#
#Seriously, install unbound, use unbound-control and/or home-grown tools
#to maintain the list of overrides, make sure the cost of filtering is
#only borne once, instead of having zsh also load a 4MB hosts file and
#parse it out.  Your system will be faster for _every_ hostname-resolving
#package, not just zsh.
#
#Otherwise, use zstyle to set 'hosts':
#
#  zstyle ':completion:*:hosts' hosts $the_hosts_you_care_about
#
#and so override the automatic parsing of /etc/hosts.