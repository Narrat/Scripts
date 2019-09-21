#!/bin/sh
#
# simple wrapper for dynamic menues like dmenu (or rofi in dmenu mode)
# Target is to create a menu that allows more specific startup commands
# (I miss sth like *box menu on tiling wm)
# For the moment the items are only cli ones-
# Geometry parameters remain for openbox.
#

# Terminal emulator
TE=kitty

#DMENU='dmenu -i -b'
DMENU='rofi -hide-scrollbar -columns 15 -dmenu -l 1 -i -p Menu:'
menitem=$(echo -e "ALSA\nBPython\nCanto\nGnuplot\nJulia\nncmpc\nOctave\nViFM\nWeeChat" | $DMENU)

case "$menitem" in
  ALSA)         $TE --class=Audio --title=ALSA -e alsamixer ;;
  Canto)        $TE --class=Science --title=canto -e /usr/bin/canto-curses ;;
  Gnuplot)      $TE --class=Science -d ${HOME}/Gnuplot --title=Gnuplot -e gnuplot ;;
  Julia)        $TE --class=Science -d ${HOME}/Octave/JuliaPort --title=Julia -e julia ;;
  ncmpc)        $TE --class=Audio --title=ncmpc -e ncmpc ;;
  Octave)       $TE --class=Science -d ${HOME}/Octave --title=Octave -e octave-cli ;;
  ViFM)         $TE --class=FileMan --title=ViFM -o initial_window_width=1300 -o initial_window_height=900 -e vifm ;;
  WeeChat)      $TE --class=WeeChat --class=WeeChat -o initial_window_width=1550 -o initial_window_height=900 -e weechat ;;
esac
