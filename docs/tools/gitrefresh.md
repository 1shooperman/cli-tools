---
layout: default
title: gitrefresh
parent: Tools
nav_order: 2
---

# gitrefresh

Resets a local clone to a clean, up-to-date state against any branch, then prunes stale local branches.

## Usage

```sh
gitrefresh          # resets to main
gitrefresh dev      # resets to dev
```

## Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `branch` | `main` | Branch to check out and pull |

## What it does

1. Checks out `branch`
2. Fetches from origin
3. Pulls latest
4. Runs `gitprune --force` **twice** — the second pass catches branches whose delete tracking refs were only cleaned up by the first pass

All git output is collapsed into a single overwriting status line.

## Notes

`gitrefresh` is a "nuke and reset" convenience — it force-prunes unmerged branches. Use plain `gitprune` if you want to keep unmerged work.
