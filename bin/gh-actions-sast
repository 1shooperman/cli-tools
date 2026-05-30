#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

EXCLUDE_LIST=()

MIN_VERSION=6

is_excluded() {
  local action="$1"
  for ex in "${EXCLUDE_LIST[@]}"; do
    [[ "$ex" == "$action" ]] && return 0
  done
  return 1
}

found_error=0

while IFS= read -r file; do
  while IFS= read -r line; do
    if [[ "$line" =~ (actions/[a-zA-Z-]+)@v([0-9]+) ]]; then
      action="${BASH_REMATCH[1]}"
      version="${BASH_REMATCH[2]}"
      if (( version < MIN_VERSION )); then
        if is_excluded "$action"; then
          echo -e "${YELLOW}WARN${RESET}  $file: $action@v$version is below v$MIN_VERSION (excluded)"
        else
          echo -e "${RED}ERROR${RESET} $file: $action@v$version is below v$MIN_VERSION"
          found_error=1
        fi
      fi
    fi
  done < "$file"
done < <(find .github/workflows -name '*.yml' 2>/dev/null)

exit $found_error
