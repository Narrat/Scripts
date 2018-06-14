#!/bin/sh
#
# simple wrapper for dynamic menues like dmenu (or rofi in dmenu mode)
# Target is to create a menu that allows more specific startup commands
# (I miss sth like *box menu on tiling wm)
# For the moment the items are only cli ones-
# Geometry parameters remain for openbox.
#

# Host based terminal sizes
if [ "$(hostname)" = "Hekate" ]
then
    _size1="--geometry=150x55"
    _size2="--geometry=195x52"
elif [ "$(hostname)" = "Persephone" ]
then
    _size1="--geometry=110x45"
    _size2=""
else
    _size1=""
    _size2=""
fi

#DMENU='dmenu -i -b'
DMENU='rofi -hide-scrollbar -columns 15 -dmenu -l 1 -i -p Menu:'
menitem=$(echo -e "ALSA\nBPython\nCanto\nGnuplot\nJulia\nncmpc\nOctave\nViFM\nWeeChat" | $DMENU)

case "$menitem" in
  ALSA)         termite --role=Audio -t ALSA -e alsamixer ;;
  Canto)        termite --role=Science -t canto -e /usr/bin/canto-curses ;;
  Gnuplot)      termite --role=Science -d ${HOME}/Gnuplot --title=Gnuplot -e gnuplot ;;
  Julia)        termite --role=Science -d ${HOME}/Octave/JuliaPort --title=Julia -e julia ;;
  ncmpc)        termite --role=Audio -t ncmpc -e ncmpc ;;
  Octave)       termite --role=Science -d ${HOME}/Octave --title=Octave -e octave-cli ;;
  ViFM)         termite --role=FileMan ${_size1} -t ViFM -e vifm ;;
  WeeChat)      termite --role=WeeChat ${_size2} -e weechat ;;
esac
