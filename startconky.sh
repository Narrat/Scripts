#!/bin/bash
#conky -c ~/.conkyscripts/.conkyrc_basic;
#conky -c ~/.conkyscripts/.conkyrc_port;
#echo Start: $(date) >> IP
#wget http://checkip.dyndns.org/ -q -O - |
#grep -Eo '\<[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}\>' >> IP
#sleep 5 &&
#xmms2-launcher
#echo Starte Canto-Daemon...
#canto-daemon &
#echo ...done
sleep 5 &&
echo Starte Conky-Skripte...
conky -c ~/.conkyscripts/conkyrc_basic -q &
sleep 10 &&
conky -c ~/.conkyscripts/conkyrc_port -q &
echo ...done