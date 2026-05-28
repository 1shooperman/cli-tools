# cli-tools

Personal shell utilities for git branch hygiene and GPG cache warming.

## Installation

Add `bin/` to your `$PATH`:

```sh
export PATH="$PATH:/path/to/cli-tools/bin"
```

## Tools

### `gitprune [--force]`

Deletes local branches that no longer exist on the remote, then runs `git gc` and `git fetch -p`.

| Flag | Behavior |
|------|----------|
| _(none)_ | Safe delete — skips unmerged branches (`-d`) |
| `--force` | Force delete — removes unmerged branches too (`-D`) |

```sh
gitprune          # safe
gitprune --force  # nuke unmerged branches too
```

### `gitrefresh [branch]`

Checks out a branch (default: `main`), pulls the latest, then force-prunes stale local branches twice to handle cascading deletions.

```sh
gitrefresh        # resets to main
gitrefresh dev    # resets to dev
```

### `cache-gpg`

Warms the GPG agent cache by performing a throwaway clearsign. Useful to pre-unlock the key before a commit flow that requires signing.

```sh
cache-gpg
```

## Structure

```
bin/
  cache-gpg     # warms GPG agent cache
  gitprune      # wrapper for gitprune()
  gitrefresh    # wrapper for gitrefresh()
lib/
  gitcmds.sh    # shared function definitions
```

## License

MIT — see [LICENSE](LICENSE).
