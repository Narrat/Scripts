#!/bin/bash
# nvidia -> nouveau

set -e

# check if root
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script. Aborting...";
   exit 1;
fi

pacman -Rdds --noconfirm nvidia-340xx-lts nvidia-340xx-utils nvidia-340xx-libgl #lib32-nvidia-utils, nvidia{,-utils,-libgl}
pacman -S --noconfirm mesa-dri xf86-video-nouveau #lib32-nouveau-dri

# If Early KMS is used
#sed -i 's/#*MODULES="nouveau"/MODULES="nouveau"/' /etc/mkinitcpio.conf
#mkinitcpio -p linux

# Move Nvidia config away
mv -v "/etc/X11/xorg.conf" "/etc/X11/nvid.xorg.conf.back"
