#!/usr/bin/env bash

GREEN='\033[32m'
GREY='\033[2m'
RESET='\033[0m'

gecho() { printf "${GREEN}%s${RESET}\n" "$*"; }

show_progress() {
    while IFS= read -r line; do
        printf "\r${GREY}%-120s${RESET}" "${line:0:120}"
    done
    printf "\r%-120s\r" ""
}

gitprune() {
    gecho "Pruning local git branches"

    if [[ "$1" == "--force" ]]; then
        gecho "Force deleting unmerged branches"
        git branch -r | awk '{print $1}' | grep -Ev -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs -r git branch -D
    else
        git branch -r | awk '{print $1}' | grep -Ev -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs -r git branch -d
    fi

    { git gc --prune=now && git fetch -p; } 2>&1 | show_progress
    gecho "Running garbage collection"
    git gc 2>&1 | show_progress
    gecho "[DONE] Pruned and cleaned."
}

gitrefresh() {
    local branch="${1:-main}"
    gecho "Refreshing local clone → $branch"
    git checkout "$branch" 2>&1 | show_progress
    git fetch origin 2>&1 | show_progress
    git pull 2>&1 | show_progress
    gitprune --force > /dev/null 2>&1
    gitprune --force
}
