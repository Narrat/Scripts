package main

/*
 * repocheck
 * This small program is intended to replace some crude shell functions which I use to mass check for repo updates.
 * Functions in question:
 * # Check AUR Repos for updates
 * aurcheck() {
 *     pushd -q $HOME/Builds/AUR
 *     find . -maxdepth 2 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} fetch
 *     popd -q
 * }
 *
 * # Check own AUR Repos for updates
 * aurcheckown() {
 *     pushd -q $HOME/Builds/Maint/AUR4
 *     find . -maxdepth 2 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} fetch
 *     popd -q
 * }
 *
 * # Search for git repos in a folder and fetch origin
 * $ find . -maxdepth 2 -name .git -type d | rev | cut -c 6- | rev | sort | xargs -I {} git -C {} fetch --prune --all
 *
 * Those three variations could be unified, but it kinda looked like a hassle.
 * Therefore this small program, which checks by default the current working directory.
 * If an path is supplied as an argument it will change to this folder.
 * Reads all items in the specified location and checks for folders and git repos.
 * If those checks are positive it will fetch the remotes.
 */

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/go-git/go-git/v5"
)

func main() {
	if len(os.Args) > 1 {
		// If there is an argument try to change the cwd to this place
		err := os.Chdir(os.Args[1])
		if err != nil {
			log.Fatal(err)
		}
	}

	// Read current dir
	files, err := os.ReadDir(".")
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		fi, err := os.Stat(file.Name())
		if err != nil {
			log.Println(err)
		}

		if fi.IsDir() {
			// is a directory, so check if it's a git dir
			gi, err := git.PlainOpen(file.Name())
			if err == nil {
				remotes, err_fetch := gi.Remotes()
				if err_fetch != nil {
					fmt.Printf(" :: Couldn't get remotes from '%s' (%v)\n", file.Name(), err)
					continue
				}

				// Work through remote list
				for _, val := range remotes {
					// Get remote name (why is space and tab mixed?)
					rem_name := strings.Split(val.String(), "\t")
					// and the actual "git fetch" operation
					err := val.Fetch(&git.FetchOptions{})
					if err == nil {
						fmt.Printf(" :: %s has updates with remote '%s'\n", file.Name(), rem_name[0])
					} else if err != git.NoErrAlreadyUpToDate {
						fmt.Printf(" :: %s had an unexpected event with remote '%s' (%v)\n", file.Name(), rem_name[0], err)
					}
				}
			}
		}
	}
}
