#!/bin/bash

# check if root
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script. Aborting...";
   exit 1;
fi

BRANCH=-340xx # Enter a branch if needed, i.e. -340xx or -304xx
ADD=-lts
NVIDIA=nvidia${BRANCH} # If no branch entered above this would be "nvidia"
NOUVEAU=xf86-video-nouveau

# Replace -R with -Rs to if you want to remove the unneeded dependencies
if [ $(pacman -Qqs ^mesa-libgl$) ]; then
    pacman -S ${NVIDIA}${ADD} ${NVIDIA}-libgl # Add lib32-${NVIDIA}-libgl and ${NVIDIA}-lts if needed
    # pacman -R $NOUVEAU
elif [ $(pacman -Qqs ^${NVIDIA}$) ]; then
    pacman -S --needed $NOUVEAU mesa-libgl # Add lib32-mesa-libgl if needed
    pacman -R ${NVIDIA}${ADD} ${NVIDIA}-util # Add ${NVIDIA}-lts if needed
fi
