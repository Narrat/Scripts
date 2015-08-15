#!/bin/bash
#
# Stuff which isn't tracked via the git repo (binary blob or whatever)
#
# TODO:
# For-Schleife? bzw zweifache For-Schleife um den redundanten Kram weiter zu entfernen. Oder zumindest für die einzelnen Programme
# Momentane Probleme: Wenn ganze Ordner gesichert werden sollen, wie soll ich testen, ob einzelne Dateien 0 byte haben?

# Which location am I executed from?
HNAME=$(hostname)

if [ $HNAME == "Hekate" ]; then
    echo 'Desktop'
    BACKPATH="Backup/Comp/ArchDesk/"
    FFPATH=".mozilla/firefox/bnvlq9xm.Crebiz/"
elif [ $HNAME == "Persephone" ]; then
    echo 'Laptop'
    BACKPATH="Backup/Comp/ArchLap/"
    #FFPATH=".mozilla/firefox/p64cifs6.default/"
    FFPATH=".mozilla/firefox/bnvlq9xm.Crebiz/"
else
    echo 'Location nicht erkannt'
fi

# Paths:
ffbook="${FFPATH}bookmarkbackups/$(ls ${FFPATH}bookmarkbackups/ | tail -n1)"
ffbookback="${BACKPATH}Browser/FFBookmarks.jsonlz4"
ffsession="${FFPATH}sessionstore.js"
ffsessionback="${BACKPATH}Browser/FFsessionstore.bak"

midoribook=".config/midori/bookmarks.db"
midoribookback="${BACKPATH}Browser/Midori_bookmarks.db"
#----------------------
# Backup md5
md5BFF=$( md5sum ${ffbookback} | awk '{print $1}' )
md5BFFs=$( md5sum ${ffsessionback} | awk '{print $1}' )

md5BMI=$( md5sum ${midoribookback} | awk '{print $1}' )
#----------------------
# To save md5
md5FF=$( md5sum ${ffbook} | awk '{print $1}' )
md5FFs=$( md5sum ${ffsession} | awk '{print $1}' )

md5MI=$( md5sum ${midoribook} | awk '{print $1}' )
#----------------------
# Firefox related
if [ -s ${ffbook} ]; then
	if [ ${md5BFF} = ${md5FF} ]; then
		echo Backup der Firefox Lesezeichen ist aktuell
	else
		cp ${ffbook} ${ffbookback}
		echo Backup der Firefox Lesezeichen erneuert
	fi
else
	echo Null-Fehler bei der aktuellen Firefox Lesezeichen Datei...
fi

if [ -s ${ffsession} ]; then
    if [ ${md5BFFs} = ${md5FFs} ]; then
        echo Backup der Firefox Session ist aktuell
    else
        cp ${ffsession} ${ffsessionback}
        echo Backup der Firefox Session erneuert
    fi
else
    echo Null-Fehler bei der Firefox Session Datei...
fi

# Midori related
if [ -s ${midoribook} ]; then
    if [ ${md5BMI} = ${md5MI} ]; then
        echo Backup der Midori Lesezeichen ist aktuell
    else
        cp ${midoribook} ${midoribookback}
        echo Backup der Midori Lesezeichen erneuert
    fi
else
    echo Null-Fehler bei der Midori Lesezeichen Datei...
fi
