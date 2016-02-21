#!/bin/sh
#
# simple wrapper for dynamic menues like dmenu (or rofi in dmenu mode)
# Target is to create a menu that allows more specific startup commands
# (I miss sth like *box menu on tiling wm)
# For the moment the items are only the cli ones
# Geometry parameter remain for openbox
#

#DMENU='dmenu -i -b'
DMENU='rofi -hide-scrollbar -columns 15 -dmenu -l 1 -i -p Menu:'
menitem=$(echo -e "ALSA\nBPython\ncanto\nGnuplot\nJulia\nncmpc\nOctave\nSmuxi-STFL\nViFM" | $DMENU)

case "$menitem" in
  ALSA)         termite --role=Audio -t ALSA -e alsamixer ;;
  BPython)      termite --role=Science -d ${HOME}/Programmieren/Sprachen/Python --title=BPython -e bpython ;;
  canto)        termite --role=Science -t canto -e /usr/bin/canto-curses ;;
  Gnuplot)      termite --role=Science -d ${HOME}/Gnuplot --title=Gnuplot -e gnuplot ;;
  Julia)        termite --role=Science -d ${HOME}/Octave/JuliaPort --title=Julia -e julia ;;
  ncmpc)        termite --role=Audio -t ncmpc -e ncmpc ;;
  Octave)       termite --role=Science -d ${HOME}/Octave --title=Octave -e octave-cli ;;
  Smuxi-STFL)   termite --role=Smuxi --geometry=110x45 -t Smuxi-STFL -e smuxi-frontend-stfl ;;
  ViFM)         termite --role=FileMan --geometry=110x45 -t ViFM -e vifm ;;
esac
