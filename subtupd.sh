#!/usr/bin/sh
#
# SUBTreeUPDate
#
# Managing my subtrees for the single Repo

# Declaration: Usage
if [ $# -ne 1 ] ; then
    echo "Usage: $0 SubTreeFolder"
    exit $E_NO_ARGS
fi

# Declaration: Variables
INPUT=$1
AUR4DIR="$HOME/Builds/Maint/AUR4"
SINGLREPDIR="$HOME/Builds/Maint/PKGBuilds"

# Declaration: Functions
# https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

function is_subtree() {
    # Gen list of subtrees
    # Not using git log --grep because it also added commit hashes
    POSTREE=$1
    SUBTREES=($(git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq))

    if [ $(contains "${SUBTREES[@]}" "${POSTREE}") == "y" ]
    then
        echo "y"
        return 0
    else
        echo "n"
        return 1
    fi
}

# ---------
# Generate lists of the content from both directories
shopt -s nullglob
cd $AUR4DIR
AFOLDER=(*/)
cd $SINGLREPDIR
SFOLDER=(*/)
shopt -u nullglob

# Check if INPUT is in AFOLDER
if [ $(contains "${AFOLDER[@]}" "${INPUT}/") == "y" ] # Extra slash added, so I don't need to remove the others
then
    echo "Found as AUR4-Repo"
    echo "Checking for existance in the single repo..."
    if [ $(contains "${SFOLDER[@]}" "${INPUT}/") == "y" ] && [ $(is_subtree ${INPUT}) == "y" ]
    then
        echo -e "Found as subtree\nTry to update...\n"
        git subtree pull --prefix="$INPUT" "${INPUT}-aur" master -m "Merge ${INPUT}-aur"
    else
        # Not found in single repo as subtree --> add it
        echo -e "Not found as subtree in the single repo\nAdding it...\n"
        # Delete folder if it still exists
        if [ -d "${INPUT}" ]; then
            git rm -r ${INPUT}
            if [ -d "${INPUT}" ]; then
                # Contains untracked items
                rm -r "${INPUT}"
            fi
            git commit -m "${INPUT}: Maintained on AUR, replaced by subtree"
        fi
        git remote add ${INPUT}-aur "${AUR4DIR}/${INPUT}"
        git subtree add --prefix="$INPUT" "${INPUT}-aur" master
    fi
else
    echo "${INPUT} not in ${AUR4DIR}"
    exit 0
fi
