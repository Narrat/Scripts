#!/usr/bin/sh
#
# Small script to download signature files for repo packages, so downgrading with -U will work
# until https://bugs.archlinux.org/task/33091 is implemented
#

# check if root
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script. Aborting...";
   exit 1;
fi

# Pacman package cache. Sig files needs to stored there
PACCACHE="/var/cache/pacman/pkg"

# check for sig files of missing packages (due to paccache or -Sc/-Scc)
del_dispensable_sig () {
    # Check if ajsldjl
    for sig_file in ${PACCACHE}/*.sig; do
        if [[ -e $sig_file ]]; then
            if [[ ! -e ${sig_file/.sig/} ]]; then
                echo "Deleting ${sig_file}"
                rm -v "${sig_file}"
            fi
        else
            echo "No signature files"
        fi
    done
}

# create list of packages and download the signature files
download_sig_file () {
    FULLP=$1
    PACKAGE=$(basename $1)
    PACKAGENAME=$(bsdtar -O -xf ${FULLP} .PKGINFO | grep pkgname | awk '{ print $3 }')
    FIRSTL=${PACKAGE:0:1}

    # Construct the URL (https://archive.archlinux.org)
    ALA_URL="https://archive.archlinux.org/packages/${FIRSTL}/${PACKAGENAME}/${PACKAGE}.sig"
    echo "Downloading ${PACKAGE}.sig"
    curl -s -o "${FULLP}.sig" ${ALA_URL}
}

# Main body
echo -e "Checking if Signature files can be deleted\n"
del_dispensable_sig

echo -e "\n\nChecking if Signature files can be downloaded\n"
for pac_file in ${PACCACHE}/*.xz; do
    if [[ -e $pac_file ]]; then
        if [[ ! -e ${pac_file}.sig ]]; then
            download_sig_file ${pac_file}
        fi
    else
        echo "No packages from the repositories"
    fi
done
