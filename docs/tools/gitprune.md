---
layout: default
title: gitprune
parent: Tools
nav_order: 1
---

# gitprune

Deletes local git branches that no longer exist on the remote, then runs garbage collection and prunes stale remote-tracking refs.

## Usage

```sh
gitprune          # safe delete
gitprune --force  # force delete unmerged branches too
```

## Flags

| Flag | Behavior |
|------|----------|
| _(none)_ | Uses `git branch -d` — refuses to delete unmerged branches |
| `--force` | Uses `git branch -D` — deletes unmerged branches regardless |

## What it does

1. Lists remote branches
2. Compares against local tracking branches
3. Deletes any local branch with no matching remote
4. Runs `git gc --prune=now` and `git fetch -p` to clean up stale refs
5. Runs `git gc` again for a final compaction

Output from gc and fetch is collapsed into a single overwriting status line so it doesn't flood your terminal.

## Notes

- Safe to run frequently — without `--force` it will never delete a branch with unmerged commits
- `gitrefresh` calls `gitprune --force` automatically at the end of its flow
