#!/usr/bin/fish
# PKGBuildSubTREE
# Small helper script to hopefully help with subtree handling
# (although to be fair: git subtree commands luckily aren't that difficult)
# It replaces "subtupd.sh" which worked fine enough, but was kinda locked.

# Argument parsing
argparse h/help -- $argv
or return

# If -h or --help is given, we print a little help text and return
if set -ql _flag_help
    echo "pkgbstree [git action] [pkgname]"
    return 0
end

# If no -h given, check if there is at least one argument.
# As for fetch it isn't mandatory to have second one.
argparse --min-args=1 -- $argv
or return

# Helper function definitions

# Main function definitions
function subtreeadd
    # --> search for name in various locations (AUR, AUR4, Pending, NotAUR...)
    # --> not there add repo URLs (aurweb, arch gitlab)
    # --> BUT first verify how rebases and subtrees work together
    # --> AND how to decide on merge or rebase (or just rebase for everything?)
    # $ git remote add <name> <url>
    # --> maybe differentiate between fetch-url (https) and push-url (ssh)
    # --> how to name the remotes? Previously was $pkgname + "-aur" which could be now misleading
    # $ REPO=<name> git subtree --prefix $REPO/ add $(string join '-' $REPO 'aur') master
    # --> check if it already available
    # --> and if available is it a subtree
    # --> if not remove the files beforehand
    echo $(string join ' ' ":: Adding new subtree" $pkgname)
    echo ":: ... if this was already implemented..."
end

function subtreefetch
    if test -n "$pkgname"
        if path filter -q --type dir $pkgname
            set -l reporem $(string join '-' $pkgname 'aur')
            echo $(string join ' ' ":: Fetching changes for" $pkgname)
            git fetch --prune $reporem
        else
            echo $(string join ' ' "::" $pkgname "does not exist")
            return 1
        end
    else
        echo ":: Fetching changes from all remotes"
        git fetch --prune --all
    end
end

function subtreemerge
    set -l curdate $(date --rfc-3339=date)
    set -l message $(string join '' $curdate ": " "Merge updates for " $REPO )
    set -l reporem $(string join '-' $pkgname 'aur')

    echo $(string join ' ' ":: Merge changes for" $pkgname "from remote" $reporem)
    git subtree --prefix $pkgname/ merge $reporem master -m "$message"
end

function subtreepush
    set -l reporem $(string join '-' $pkgname 'aur')

    echo $(string join ' ' ":: Pushing changes for" $pkgname "to remote" $reporem)
    git subtree --prefix $pkgname/ push $reporem master
end

function subtreerm
    set -l curdate $(date --rfc-3339=date)
    set -l message $(string join '' $curdate ": " "Remove " $pkgname )
    set -l reporem $(string join '-' $pkgname 'aur')

    echo $(string join ' ' ":: Remove subtree" $pkgname "and the respective remote" $reporem)
    git rm -r $pkgname
    and git commit -m "$message"
    and git remote remove $reporem
end

# Set variables
set -g gitaction $argv[1]
set -g pkgname $argv[2]

set -g workdir $HOME/Builds/Maint/PKGBuilds/
set -g locations \
    $HOME/Builds/ARCH/ \
    $HOME/Builds/AUR/ \
    $HOME/Builds/Maint/AUR4/ \
    $HOME/Builds/Maint/Pending/ \
    $HOME/Builds/Maint/NotAUR/ \
    $HOME/Builds/__NotAUR4/

# Only fetch is allowed to have a missing second argument
if not test -n "$pkgname" && test "$gitaction" != fetch
    echo $(string join ': ' ":" $gitaction "Missing second argument" )
    return 1
end

# Switch to workdir if it exists
# (and maybe only if not already located there)
if path filter -q --type dir $workdir
    cd "$workdir"
else
    echo ":: Main repo doesn't exist"
    return 1
end

# Main switch
switch $gitaction
    case add
        subtreeadd
    case fetch
        subtreefetch
    case merge
        subtreemerge
    case push
        subtreepush
    case remove
        subtreerm
    case '*'
        echo $(string join ' ' "::" $gitaction  "is not a valid command!")
        return 1
end
