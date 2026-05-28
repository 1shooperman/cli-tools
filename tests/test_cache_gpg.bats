#!/usr/bin/env bats

SCRIPT="$BATS_TEST_DIRNAME/../bin/cache-gpg"

setup() {
  MOCK_BIN="$(mktemp -d)"
}

teardown() {
  rm -rf "$MOCK_BIN"
}

mock_gpg() {
  local exit_code="${1:-0}"
  cat > "$MOCK_BIN/gpg" <<EOF
#!/bin/bash
cat > /dev/null
exit $exit_code
EOF
  chmod +x "$MOCK_BIN/gpg"
}

@test "cache-gpg: script is executable" {
  [ -x "$SCRIPT" ]
}

@test "cache-gpg: has bash shebang" {
  head -1 "$SCRIPT" | grep -q 'bash'
}

@test "cache-gpg: exits 0 when gpg succeeds" {
  mock_gpg 0
  PATH="$MOCK_BIN:$PATH" run "$SCRIPT"
  [ "$status" -eq 0 ]
}

@test "cache-gpg: exits non-zero when gpg fails" {
  mock_gpg 2
  PATH="$MOCK_BIN:$PATH" run "$SCRIPT"
  [ "$status" -ne 0 ]
}
