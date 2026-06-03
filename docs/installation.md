---
layout: default
title: Installation
nav_order: 2
---

# Installation

## Homebrew (recommended)

```sh
brew tap 1shooperman/tap
brew install cli-tools
```

All commands are placed on your `$PATH` automatically.

---

## Manual

Clone the repo and add `bin/` to your `$PATH`:

```sh
git clone https://github.com/1shooperman/cli-tools.git
export PATH="$PATH:/path/to/cli-tools/bin"
```

Add the `export` line to your shell rc file (`.zshrc`, `.bashrc`, etc.) to persist it across sessions.

---

## Dependencies

Some commands require external tools. Install only what you need:

| Tool | Required by | Install |
|------|-------------|---------|
| `ffmpeg` | `convert-video` | `brew install ffmpeg` |
| `gpg` | `cache-gpg` | `brew install gnupg` |
| `git` | `gitprune`, `gitrefresh` | ships with macOS |
