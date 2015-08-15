#!/bin/sh
#
# simple wrapper for dynamic menues like dmenu (or rofi in dmenu mode)
# Target is to create a menu that allows more specific startup commands
# (I miss sth like *box menu on tiling wm)
# For the moment the items are only the cli ones
# Geometry parameter remain for openbox
#

#DMENU='dmenu -i -b'
DMENU='rofi -columns 15 -dmenu -l 1 -i -p Menu:'
menitem=$(echo -e "ALSA\nBPython\ncanto\nCDW\nGnuplot\nJulia\nncmpc\nOctave\nSmuxi-STFL\nViFM" | $DMENU)

case "$menitem" in
  ALSA)         roxterm --role=Audio -T ALSA -e alsamixer ;;
  BPython)      roxterm --role=Science -d ${HOME}/Programmieren/Sprachen/Python --title=BPython -e bpython ;;
  canto)        roxterm --role=Science -T canto -e /usr/bin/canto-curses ;;
  CDW)          roxterm --role=cdw --geometry=110x45 -T cdw -e /usr/bin/cdw ;;
  Gnuplot)      roxterm --role=Science -d ${HOME}/Gnuplot --title=Gnuplot -e gnuplot ;;
  Julia)        roxterm --role=Science -d ${HOME}/Octave/JuliaPort --title=Julia -e julia ;;
  ncmpc)        roxterm --role=Audio -T ncmpc -e ncmpc ;;
  Octave)       roxterm --role=Science -d ${HOME}/Octave --title=Octave -e octave-cli ;;
  Smuxi-STFL)   roxterm --role=Smuxi --geometry=110x45 -T Smuxi-STFL -e smuxi-frontend-stfl ;;
  ViFM)         roxterm --role=FileMan --geometry=110x45 -T ViFM -e vifm ;;
esac
