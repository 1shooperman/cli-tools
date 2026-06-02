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
