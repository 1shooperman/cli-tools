#!/usr/bin/env bats

BOOTSTRAP="$BATS_TEST_DIRNAME/../bin/_bootstrap"

@test "sources without error" {
  run bash -c "source '$BOOTSTRAP'"
  [ "$status" -eq 0 ]
}

@test "sets CLI_TOOL_ROOT to a non-empty path" {
  run bash -c "source '$BOOTSTRAP'; echo \"\$CLI_TOOL_ROOT\""
  [ "$status" -eq 0 ]
  [[ "$output" != "" ]]
}

@test "CLI_TOOL_ROOT contains bin/ and lib/" {
  run bash -c "source '$BOOTSTRAP'; [ -d \"\$CLI_TOOL_ROOT/bin\" ] && [ -d \"\$CLI_TOOL_ROOT/lib\" ]"
  [ "$status" -eq 0 ]
}

@test "CLI_TOOL_ROOT is exported to child processes" {
  run bash -c "source '$BOOTSTRAP'; bash -c 'echo \"\$CLI_TOOL_ROOT\"'"
  [ "$status" -eq 0 ]
  [[ "$output" != "" ]]
}
