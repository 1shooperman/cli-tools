---
layout: default
title: sast
parent: Tools
nav_order: 5
---

# sast

Static analysis for Claude plugin markdown files. Scans `allowed-tools` declarations in YAML frontmatter for risky tool grants.

## Usage

```sh
sast                        # scans ./plugins
sast /path/to/plugins       # scans a specific directory
```

## Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `plugins-dir` | `./plugins` (relative to CWD) | Directory to scan for `.md` files |

## Checks

| Severity | Pattern | Why it matters |
|----------|---------|----------------|
| ERROR | Bare `Bash` | Grants unrestricted shell access to any command |
| ERROR | `Bash(*)` | Wildcard constraint is effectively unrestricted |
| ERROR | `[*]`, `Agent(*)`, `Skill(*)` | Grants access to all tools or agents |
| WARN | Bare `WebFetch` | Allows fetching any domain without restriction |

Only `allowed-tools` lines within the first YAML frontmatter block (between the opening and closing `---`) are checked. Occurrences in the body are ignored.

## Exit codes

| Code | Meaning |
|------|---------|
| `0` | No ERROR findings (WARN-only still exits 0) |
| `1` | One or more ERROR findings |

## Example output

```
[ERROR] plugins/my-agent/agent.md: bare 'Bash' grants unrestricted shell access
[WARN]  plugins/my-agent/agent.md: bare 'WebFetch' allows fetching any domain

SAST complete. Findings: 2
```

## Notes

- Designed to run in CI against a checked-out repo, or locally from a project root
- Exits 0 cleanly when `plugins-dir` does not exist (0 findings)
- Pairs with [`gh-actions-sast`](gh-actions-sast) for broader CI security coverage
