---
layout: default
title: gh-actions-sast
parent: Tools
nav_order: 6
---

# gh-actions-sast

Scans GitHub Actions workflow files for action references pinned below a minimum version.

## Usage

```sh
gh-actions-sast
```

Must be run from the repository root. Scans `.github/workflows/*.yml` automatically — no arguments needed.

## What it does

Walks every `.yml` file under `.github/workflows/` and checks each `uses:` line for `actions/*@vN` references. Any action pinned below `v6` is flagged.

## Output

| Severity | Condition |
|----------|-----------|
| ERROR | Action version is below `v6` |
| WARN | Action is below `v6` but present in the exclude list |

```
ERROR ci.yml: actions/checkout@v4 is below v6
WARN  ci.yml: actions/some-action@v3 is below v6 (excluded)
```

## Exit codes

| Code | Meaning |
|------|---------|
| `0` | No ERROR findings |
| `1` | One or more ERROR findings |

## Notes

- Only matches the pattern `actions/<name>@v<number>` — SHA-pinned or tag-pinned refs are not checked
- Passes cleanly when `.github/workflows/` does not exist
- Non-`.yml` files in `.github/workflows/` are skipped
- Pairs with [`sast`](sast) for broader CI security coverage
