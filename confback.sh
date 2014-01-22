#!/bin/bash
# TODO:
# For-Schleife? bzw zweifache For-Schleife um den redundanten Kram weiter zu entfernen. Oder zumindest für die einzelnen Programme
# Alles was gesichert werden soll
# Evtl mit Option wohin gesichert werden soll (USB-Stick, oder normaler Backup Ordner)
# Momentane Probleme: Wenn ganze Ordner gesichert werden sollen, wie soll ich testen, ob einzelne Dateien 0 byte haben?

# Paths:
ffbook=".mozilla/firefox/bnvlq9xm.Crebiz/bookmarkbackups/bookmarks-$(date +%Y-%m-%d)*.json"
ffback="Backup/Comp/ArchDesk/Browser/FFBookmarks.json"

canto=".canto-ng/conf"
cantob="Backup/Comp/ArchDesk/Canto/conf"

dwb1=".config/dwb/settings"
dwb1b="Backup/Comp/ArchDesk/dwb/settings"
dwb2=".config/dwb/keys"
dwb2b="Backup/Comp/ArchDesk/dwb/keys"
dwb3=".config/dwb/searchengines"
dwb3b="Backup/Comp/ArchDesk/dwb/searchengines"
dwb4=".config/dwb/default/bookmarks"
dwb4b="Backup/Comp/ArchDesk/dwb/default/bookmarks"
dwb5=".config/dwb/default/quickmarks"
dwb5b="Backup/Comp/ArchDesk/dwb/default/quickmarks"

conky1=".conkyscripts/conkyrc_basic"
conky1b="Backup/Comp/ArchDesk/conkyscripts/conkyrc_basic"
conky2=".conkyscripts/conkyrc_port"
conky2b="Backup/Comp/ArchDesk/conkyscripts/conkyrc_port"
conky3=".conkyscripts/publicip.sh"
conky3b="Backup/Comp/ArchDesk/conkyscripts/publicip.sh"

ob1=".config/openbox/rc.xml"
ob1b="Backup/Comp/ArchDesk/Openbox/rc.xml"
ob2=".config/openbox/menu.xml"
ob2b="Backup/Comp/ArchDesk/Openbox/menu.xml"
ob3=".config/openbox/autostart"
ob3b="Backup/Comp/ArchDesk/Openbox/autostart"
#----------------------
# Backup md5
md5BFF=$( md5sum ${ffback} | awk '{print $1}' )

md5BCanto=$( md5sum ${cantob} | awk '{print $1}' )

md5Bdwb1=$( md5sum ${dwb1b} | awk '{print $1}' )
md5Bdwb2=$( md5sum ${dwb2b} | awk '{print $1}' )
md5Bdwb3=$( md5sum ${dwb3b} | awk '{print $1}' )
md5Bdwb4=$( md5sum ${dwb4b} | awk '{print $1}' )
md5Bdwb5=$( md5sum ${dwb5b} | awk '{print $1}' )

md5Bconky1=$( md5sum ${conky1b} | awk '{print $1}' )
md5Bconky2=$( md5sum ${conky2b} | awk '{print $1}' )
md5Bconky3=$( md5sum ${conky3b} | awk '{print $1}' )

md5Bob1=$( md5sum ${ob1b} | awk '{print $1}' )
md5Bob2=$( md5sum ${ob2b} | awk '{print $1}' )
md5Bob3=$( md5sum ${ob3b} | awk '{print $1}' )
#----------------------
# To save md5
md5FF=$( md5sum ${ffbook} | awk '{print $1}' )

md5Canto=$( md5sum ${canto} | awk '{print $1}' )

md5dwb1=$( md5sum ${dwb1} | awk '{print $1}' )
md5dwb2=$( md5sum ${dwb2} | awk '{print $1}' )
md5dwb3=$( md5sum ${dwb3} | awk '{print $1}' )
md5dwb4=$( md5sum ${dwb4} | awk '{print $1}' )
md5dwb5=$( md5sum ${dwb5} | awk '{print $1}' )

md5conky1=$( md5sum ${conky1} | awk '{print $1}' )
md5conky2=$( md5sum ${conky2} | awk '{print $1}' )
md5conky3=$( md5sum ${conky3} | awk '{print $1}' )

md5ob1=$( md5sum ${ob1} | awk '{print $1}' )
md5ob2=$( md5sum ${ob2} | awk '{print $1}' )
md5ob3=$( md5sum ${ob3} | awk '{print $1}' )

#----------------------
# Firefox related
if [ -s ${ffbook} ]; then
	if [ ${md5BFF} = ${md5FF} ]; then
		echo Backup der Firefox Lesezeichen ist aktuell
	else
		cp ${ffbook} ${ffback}
		echo Backup der Firefox Lesezeichen erneuert
	fi
else
	echo Null-Fehler bei der aktuellen Firefox Lesezeichen Datei...
fi


# Canto related
if [ -s ${canto} ]; then
	if [ ${md5BCanto} = ${md5Canto} ]; then
		echo Backup der Canto Config ist aktuell
	else
		cp ${canto} ${cantob}
		echo Backup der Canto Config erneuert
	fi
else
	echo Null-Fehler bei der Canto Config...
fi


# Dwb related
if [ -s ${dwb1} ]; then
	if [ ${md5Bdwb1} = ${md5dwb1} ]; then
		echo Backup der Dwb Settings Datei ist aktuell
	else
		cp ${dwb1} ${dwb1b}
		echo Backup der Dwb Settings Datei erneuert
	fi
else
	echo Null-Fehler bei Dwb Settings...
fi

if [ -s ${dwb2} ]; then
	if [ ${md5Bdwb2} = ${md5dwb2} ]; then
		echo Backup der Dwb Keys Datei ist aktuell
	else
		cp ${dwb2} ${dwb2b}
		echo Backup von der Dwb Keys Datei erneuert
	fi
else
	echo Null-Fehler bei Dwb Keys...
fi

if [ -s ${dwb3} ]; then
	if [ ${md5Bdwb3} = ${md5dwb3} ]; then
		echo Backup der Dwb Searchengines Datei ist aktuell
	else
		cp ${dwb3} ${dwb3b}
		echo Backup der Dwb Searchengines Datei erneuert
	fi
else
	echo Null-Fehler bei Dwb Searchengines...
fi

if [ -s ${dwb4} ]; then
	if [ ${md5Bdwb4} = ${md5dwb4} ]; then
		echo Backup der Dwb Bookmarks ist aktuell
	else
		cp ${dwb4} ${dwb4b}
		echo Backup der Dwb Bookmarks erneuert
	fi
else
	echo Null-Fehler bei Dwb Bookmarks...
fi

if [ -s ${dwb5} ]; then
	if [ ${md5Bdwb5} = ${md5dwb5} ]; then
		echo Backup der Dwb Quickmarks ist aktuell
	else
		cp ${dwb5} ${dwb5b}
		echo Backup der Dwb Quickmarks erneuert
	fi
else
	echo Null-Fehler bei Dwb Quickmarks...
fi


# Conky related
if [ -s ${conky1} ]; then
	if [ ${md5Bconky1} = ${md5conky1} ]; then
		echo Backup der Conkyrc Basic ist aktuell
	else
		cp ${conky1} ${conky1b}
		echo Backup der Conkyrc Basic erneuert
	fi
else
	echo Null-Fehler bei Conkyrc Basic...
fi

if [ -s ${conky2} ]; then
	if [ ${md5Bconky2} = ${md5conky2} ]; then
		echo Backup der Conkyrc Port ist aktuell
	else
		cp ${conky2} ${conky2b}
		echo Backup Conkyrc Port erneuert
	fi
else
	echo Null-Fehler bei Conkyrc Port...
fi

if [ -s ${conky3} ]; then
	if [ ${md5Bconky3} = ${md5conky3} ]; then
		echo Backup vom Conky IP-Skript ist aktuell
	else
		cp ${conky3} ${conky3b}
		echo Backup vom Conky IP-Skript erneuert
	fi
else
	echo Null-Fehler bei Conky IP-Skript...
fi


# Openbox related
if [ -s ${ob1} ]; then
	if [ ${md5Bob1} = ${md5ob1} ]; then
		echo Backup der Openbox RC ist aktuell
	else
		cp ${ob1} ${ob1b}
		echo Backup der Openbox RC erneuert
	fi
else
	echo Null-Fehler bei Openbox RC...
fi

if [ -s ${ob2} ]; then
	if [ ${md5Bob2} = ${md5ob2} ]; then
		echo Backup von Openbox Menu ist aktuell
	else
		cp ${ob2} ${ob2b}
		echo Backup von Openbox Menu erneuert
	fi
else
	echo Null-Fehler bei Openbox Menu...
fi

if [ -s ${ob3} ]; then
	if [ ${md5Bob3} = ${md5ob3} ]; then
		echo Backup von Openbox autostart ist aktuell
	else
		cp ${ob3} ${ob3b}
		echo Backup von Openbox autostart erneuert
	fi
else
	echo Null-Fehler bei Openbox autostart...
fi
