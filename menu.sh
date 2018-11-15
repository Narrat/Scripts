#!/bin/sh
#
# simple wrapper for dynamic menues like dmenu (or rofi in dmenu mode)
# Target is to create a menu that allows more specific startup commands
# (I miss sth like *box menu on tiling wm)
# For the moment the items are only cli ones-
# Geometry parameters remain for openbox.
#

# Terminal emulator
TE=urxvt

#DMENU='dmenu -i -b'
DMENU='rofi -hide-scrollbar -columns 15 -dmenu -l 1 -i -p Menu:'
menitem=$(echo -e "ALSA\nBPython\nCanto\nGnuplot\nJulia\nncmpc\nOctave\nViFM\nWeeChat" | $DMENU)

case "$menitem" in
  ALSA)         $TE -name Audio -title ALSA -e alsamixer ;;
  Canto)        $TE -name Science -title canto -e /usr/bin/canto-curses ;;
  Gnuplot)      $TE -name Science -cd ${HOME}/Gnuplot -title Gnuplot -e gnuplot ;;
  Julia)        $TE -name Science -cd ${HOME}/Octave/JuliaPort -title Julia -e julia ;;
  ncmpc)        $TE -name Audio -title ncmpc -e ncmpc ;;
  Octave)       $TE -name Science -cd ${HOME}/Octave -title Octave -e octave-cli ;;
  ViFM)         $TE -name FileMan -title ViFM -e vifm ;;
  WeeChat)      $TE -name WeeChat -e weechat ;;
esac
