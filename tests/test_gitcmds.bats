#!/usr/bin/env bats

LIB="$BATS_TEST_DIRNAME/../lib/gitcmds.sh"

setup() {
  MOCK_BIN="$(mktemp -d)"
  GIT_LOG="$MOCK_BIN/git.log"

  cat > "$MOCK_BIN/git" <<'EOF'
#!/usr/bin/env bash
echo "git $*" >> "$GIT_LOG"
case "$1" in
  branch)
    if [[ "$2" == "-r" ]]; then echo "  origin/main"; fi
    if [[ "$2" == "-vv" ]]; then echo "  main abc123 [origin/main] msg"; fi
    ;;
  *) ;;
esac
exit 0
EOF
  chmod +x "$MOCK_BIN/git"

  export PATH="$MOCK_BIN:$PATH"
  export GIT_LOG
  export CLI_TOOL_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"

  # shellcheck source=../lib/gitcmds.sh
  source "$LIB"
}

teardown() {
  rm -rf "$MOCK_BIN"
}

@test "lib sources without error" {
  # sourced in setup; if we got here it worked
  true
}

@test "gitprune: function is defined" {
  declare -f gitprune > /dev/null
}

@test "gitrefresh: function is defined" {
  declare -f gitrefresh > /dev/null
}

@test "gitprune: calls git gc" {
  gitprune
  grep -q "git gc" "$GIT_LOG"
}

@test "gitprune --force: calls git fetch" {
  gitprune --force
  grep -q "git fetch" "$GIT_LOG"
}

@test "gitrefresh: defaults to main branch" {
  gitrefresh
  grep -q "git checkout main" "$GIT_LOG"
}

@test "gitrefresh: uses provided branch name" {
  gitrefresh develop
  grep -q "git checkout develop" "$GIT_LOG"
}

@test "gitrefresh: calls git pull" {
  gitrefresh
  grep -q "git pull" "$GIT_LOG"
}
