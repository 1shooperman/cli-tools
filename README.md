# cli-tools

Personal shell utilities for git branch hygiene, GPG cache warming, video conversion, and Claude plugin static analysis.

## Installation

### Homebrew (recommended)

```sh
brew tap 1shooperman/tap
brew install cli-tools
```

### Manual

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

### `convert-video [file]`

Converts a video file to H.264/AAC MP4 using ffmpeg. Output is written alongside the input with a `.mp4` extension. Requires `ffmpeg`.

```sh
convert-video input.mov
```

### `sast [plugins-dir]`

Static analysis for Claude plugin markdown files. Scans `plugins/` (default: `./plugins`) for risky `allowed-tools` declarations in YAML frontmatter.

| Severity | Check |
|----------|-------|
| ERROR | Bare `Bash` or `Bash(*)` — unrestricted shell access |
| ERROR | Wildcard `[*]`, `Agent(*)`, or `Skill(*)` — all tools granted |
| WARN | Bare `WebFetch` — any domain fetchable |

```sh
sast                        # scans ./plugins
sast /path/to/plugins       # scans a specific directory
```

Exits non-zero if any ERROR findings are found.

## Structure

```
bin/
  _bootstrap      # resolves CLI_TOOL_ROOT; sourced by all bin scripts
  cache-gpg       # warms GPG agent cache
  convert-video   # wrapper for convert_vid()
  gitprune        # wrapper for gitprune()
  gitrefresh      # wrapper for gitrefresh()
  sast            # static analysis for claude plugin frontmatter
lib/
  common.sh       # shared color vars, gecho, show_progress
  ffmpegcmds.sh   # convert_vid() implementation
  gitcmds.sh      # gitprune() and gitrefresh() implementations
```

## License

MIT — see [LICENSE](LICENSE).
