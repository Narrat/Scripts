#!/usr/bin/fish
# Crop images with imagemagick specified by a profile

# Argument parsing
argparse h/help p/profile= -- $argv
or return

# If -h or --help is given, we print a little help text and return
if set -ql _flag_help
    echo "piccrop [-h|--help] [-p|--profile] [ARGUMENT ...]"
    return 0
end

# If no -h given, check if there is an argument. If not bail
argparse --min-args=1 -- $argv
or return

# Set variables
if set -ql _flag_profile
    set -g profile $_flag_profile
    echo $profile # TEMP
end

set -g picture $argv[1]
set -g picname $(path basename -E $picture)
set -g picext $(path extension $picture)
set -g picnew $(string join '' $picname "_cr" $picext)

# TODO: Check if necessary tools are available

# Get base values of picture?
# Like Size?
set -g picprop "$(magick identify $picture +ping)"
echo $picprop # TEMP
# Check error code possible? If the picture isn't a picture the script can abort

# Profile: bots
# Values depend on a picture size of 1080x2160
magick "$picture" -crop 890x890+95+600 "$picnew"

# TODO: Put the magick command for bots into a switch
# TODO: Add banner profile
