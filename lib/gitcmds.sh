#!/usr/bin/env bash
gitprune () {
    echo "Pruning local git branches"

    if [[ "$1" == "--force" ]]; then
        echo "Force deleting unmerged branches"
        git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs -r git branch -D
    else
        git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs -r git branch -d
    fi

    git gc --prune=now
    git fetch -p
    echo "Pruning complete. Running garbage collection"
    git gc
    echo "Pruned and Cleaned."
}

gitrefresh () {
	echo "Refreshing local clone."
	if [[ "$1" != "" ]]
	then
		git checkout $1
	else
		git checkout main
	fi
	git fetch origin
	git pull
	gitprune --force
	gitprune --force
}
