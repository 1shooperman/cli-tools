#!/usr/bin/env bats

setup() {
  TMPDIR="$(mktemp -d)"
  mkdir -p "$TMPDIR/bin" "$TMPDIR/plugins/pkg"
  cp "$BATS_TEST_DIRNAME/../bin/sast" "$TMPDIR/bin/sast"
  chmod +x "$TMPDIR/bin/sast"
  SAST="$TMPDIR/bin/sast"
}

teardown() {
  rm -rf "$TMPDIR"
}

write_md() {
  cat > "$TMPDIR/plugins/pkg/agent.md"
}

@test "clean file: exits 0 with no findings" {
  write_md <<'EOF'
---
allowed-tools: [Bash(echo hello), WebFetch(https://example.com)]
---
body
EOF
  run "$SAST"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Findings: 0"* ]]
}

@test "bare Bash: flagged ERROR, exits 1" {
  write_md <<'EOF'
---
allowed-tools: [Bash, Read]
---
EOF
  run "$SAST"
  [ "$status" -eq 1 ]
  [[ "$output" == *"[ERROR]"* ]]
  [[ "$output" == *"bare 'Bash'"* ]]
}

@test "Bash(*): flagged ERROR, exits 1" {
  write_md <<'EOF'
---
allowed-tools: [Bash(*), Read]
---
EOF
  run "$SAST"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Bash(*) is effectively unrestricted"* ]]
}

@test "bare WebFetch: flagged WARN, exits 0" {
  write_md <<'EOF'
---
allowed-tools: [WebFetch, Read]
---
EOF
  run "$SAST"
  [ "$status" -eq 0 ]
  [[ "$output" == *"[WARN]"* ]]
  [[ "$output" == *"bare 'WebFetch'"* ]]
}

@test "wildcard [*]: flagged ERROR, exits 1" {
  write_md <<'EOF'
---
allowed-tools: [*]
---
EOF
  run "$SAST"
  [ "$status" -eq 1 ]
  [[ "$output" == *"wildcard '*'"* ]]
}

@test "constrained Bash(cmd): not flagged" {
  write_md <<'EOF'
---
allowed-tools: [Bash(git status), Read]
---
EOF
  run "$SAST"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Findings: 0"* ]]
}

@test "constrained WebFetch(domain): not flagged" {
  write_md <<'EOF'
---
allowed-tools: [WebFetch(https://api.example.com), Read]
---
EOF
  run "$SAST"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Findings: 0"* ]]
}

@test "allowed-tools outside frontmatter block: not scanned" {
  write_md <<'EOF'
---
name: safe
---
body text with allowed-tools: [Bash, *]
EOF
  run "$SAST"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Findings: 0"* ]]
}

@test "no plugins dir: exits 0 with no findings" {
  rm -rf "$TMPDIR/plugins"
  run "$SAST"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Findings: 0"* ]]
}

@test "multiple violations counted correctly" {
  write_md <<'EOF'
---
allowed-tools: [Bash, WebFetch]
---
EOF
  run "$SAST"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Findings: 2"* ]]
}
