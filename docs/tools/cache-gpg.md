---
layout: default
title: cache-gpg
parent: Tools
nav_order: 3
---

# cache-gpg

Warms the GPG agent cache by performing a throwaway clearsign operation.

## Usage

```sh
cache-gpg
```

No arguments. No output on success.

## Why

`git commit -S` prompts for your GPG passphrase when the agent cache is cold. Running `cache-gpg` before your commit flow pre-unlocks the key so the signing step doesn't interrupt with a passphrase prompt.

## What it does

Pipes the string `"test"` through `gpg --clearsign` and discards the output. That is enough to unlock the key and populate the agent cache for the configured cache TTL.

## Requirements

| Requirement | Install |
|-------------|---------|
| `gpg` installed and a signing key configured | `brew install gnupg` |
| GPG agent running | started automatically by `gpg` on modern systems |
