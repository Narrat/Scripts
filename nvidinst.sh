#!/bin/bash
# nouveau -> nvidia

set -e

# check if root
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script. Aborting...";
   exit 1;
fi

pacman -Rdds --noconfirm mesa-libgl #lib32-mesa lib32-mesa-libgl
pacman -S --noconfirm nvidia-340xx-lts nvidia-340xx-utils #lib32-nvidia-utils, nvidia{,-utils}

# If Early-KMS is used
#sed -i 's/MODULES="nouveau"/#MODULES="nouveau"/' /etc/mkinitcpio.conf
#mkinitcpio -p linux

# Move Nvidia config in position
mv -v "/etc/X11/nvid.xorg.conf.back" "/etc/X11/xorg.conf"
