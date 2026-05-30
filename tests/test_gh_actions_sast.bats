#!/usr/bin/env bats

setup() {
  TMPDIR="$(mktemp -d)"
  mkdir -p "$TMPDIR/.github/workflows"
  cp "$BATS_TEST_DIRNAME/../bin/gh-actions-sast" "$TMPDIR/gh-actions-sast"
  chmod +x "$TMPDIR/gh-actions-sast"
  GH_ACTIONS_SAST="$TMPDIR/gh-actions-sast"
}

teardown() {
  rm -rf "$TMPDIR"
}

write_workflow() {
  cat > "$TMPDIR/.github/workflows/ci.yml"
}

@test "no workflows dir: exits 0" {
  rm -rf "$TMPDIR/.github"
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 0 ]
}

@test "action at MIN_VERSION (v6): exits 0" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v6
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 0 ]
}

@test "action above MIN_VERSION (v7): exits 0" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v7
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 0 ]
}

@test "action below MIN_VERSION (v5): exits 1 with ERROR" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v5
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"ERROR"* ]]
  [[ "$output" == *"actions/checkout@v5"* ]]
}

@test "action at v1: exits 1 with ERROR" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/setup-node@v1
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"ERROR"* ]]
  [[ "$output" == *"actions/setup-node@v1"* ]]
}

@test "multiple old actions: all reported" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v3
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"actions/checkout@v4"* ]]
  [[ "$output" == *"actions/setup-node@v3"* ]]
}

@test "mixed old and new actions: exits 1" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-node@v3
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"actions/setup-node@v3"* ]]
}

@test "non-yml file ignored" {
  cp "$TMPDIR/.github/workflows/ci.yml" "$TMPDIR/.github/workflows/notes.txt" 2>/dev/null || true
  cat > "$TMPDIR/.github/workflows/notes.txt" <<'EOF'
uses: actions/checkout@v1
EOF
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v6
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 0 ]
}

@test "multiple workflow files: all scanned" {
  write_workflow <<'EOF'
jobs:
  test:
    steps:
      - uses: actions/checkout@v6
EOF
  cat > "$TMPDIR/.github/workflows/release.yml" <<'EOF'
jobs:
  release:
    steps:
      - uses: actions/upload-artifact@v4
EOF
  run bash -c "cd '$TMPDIR' && '$GH_ACTIONS_SAST'"
  [ "$status" -eq 1 ]
  [[ "$output" == *"actions/upload-artifact@v4"* ]]
}
