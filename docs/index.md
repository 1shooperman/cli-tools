---
layout: home
title: Home
nav_order: 1
---

# cli-tools

Personal shell utilities for git branch hygiene, GPG cache warming, video conversion, and Claude plugin static analysis.

## Quick install

```sh
brew tap 1shooperman/tap
brew install cli-tools
```

All commands are placed on your `$PATH` automatically. See [Installation](installation) for manual setup and dependencies.

---

## Tools at a glance

| Command | What it does |
|---------|-------------|
| [`gitprune`](tools/gitprune) | Deletes stale local branches and compacts the repo |
| [`gitrefresh`](tools/gitrefresh) | Resets to a clean, up-to-date state against any branch |
| [`cache-gpg`](tools/cache-gpg) | Warms the GPG agent cache before a signing flow |
| [`convert-video`](tools/convert-video) | Converts any video file to H.264/AAC MP4 via ffmpeg |
| [`sast`](tools/sast) | Static analysis for Claude plugin `allowed-tools` frontmatter |
| [`gh-actions-sast`](tools/gh-actions-sast) | Checks GitHub Actions workflows for outdated action pins |
