# Security Policy

## Reporting a Vulnerability

Report issues privately via [GitHub's private vulnerability reporting](https://github.com/bshoop/cli-tools/security/advisories/new) rather than a public issue.

Include:
- Description and potential impact
- Steps to reproduce or proof-of-concept
- Any suggested mitigations

Expect an initial response within **7 days**.

## Scope

This repo contains bash scripts that run git commands. Relevant concerns:

- `gitprune --force` deletes local branches — run only when you intend to discard unmerged work
- Scripts source `../lib/gitcmds.sh` via a relative path — ensure the `lib/` directory is not writable by untrusted processes
- No network calls beyond standard `git fetch`/`git pull` against your configured remote

## Supported Versions

Only the latest revision on `main` is maintained.
