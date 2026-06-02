#!/usr/bin/env bats

LIB="$BATS_TEST_DIRNAME/../lib/common.sh"

setup() {
  # shellcheck source=../lib/common.sh
  source "$LIB"
}

@test "sources without error" {
  true
}

@test "gecho: outputs the provided text" {
  run gecho "hello world"
  [ "$status" -eq 0 ]
  [[ "$output" == *"hello world"* ]]
}

@test "gecho: accepts multiple words" {
  run gecho "foo" "bar"
  [ "$status" -eq 0 ]
  [[ "$output" == *"foo"* ]]
}

@test "show_progress: exits 0 on empty input" {
  run bash -c "source '$LIB'; echo -n | show_progress"
  [ "$status" -eq 0 ]
}

@test "show_progress: consumes piped input without error" {
  run bash -c "source '$LIB'; printf 'line1\nline2\n' | show_progress"
  [ "$status" -eq 0 ]
}
