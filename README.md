# ssht

SSH straight into a **tmux session on the remote** — attach if it exists, create it if it
doesn't, and fall back to a plain shell if the remote has no tmux.

```sh
ssht user@server                # tmux session "main", or reattach
ssht --session deploy u@server  # named session
ssht -p 2222 -A u@server        # any ssh args just pass through
```

## Why

Plain SSH dies when your network blips or your laptop sleeps — and takes every running job
with it. Run tmux on the server and the session outlives the connection. `ssht` makes that a
single command instead of: `ssh in`, type `tmux attach || tmux new`, remember the name.

One tmux layer, on the server. No nested tmux, no config, no keybinding juggling.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/brunofin/ssht/main/install.sh | sh
```

That puts `ssht` in `~/.local/bin` (override with `PREFIX=/some/dir`). Alternatively, clone and
run the installer, or just copy the single `ssht` file anywhere on your PATH:

```sh
git clone https://github.com/brunofin/ssht
PREFIX=~/.local/bin ~/ssht/install.sh
# or: install -m 755 ~/ssht/ssht ~/.local/bin/ssht
```

Requires only `bash` locally and `tmux` on the remote (optional — plain shell fallback).

## Usage

`ssht [ssh options...] [--session NAME]`

- All arguments before `--session` are forwarded verbatim to `ssh`.
- `--session NAME` sets the remote tmux session name (default: `main`). It is parsed out
  locally and never reaches ssh.
- `-t` (TTY) is always forced, since tmux requires a terminal.

Behavior on the remote:

- tmux installed → `tmux new -A -s NAME` (attach, or create if missing).
- tmux missing → a warning on stderr, then your plain login shell. Your connect scripts keep
  working on any box.

## Examples

```sh
# one server, reconnect anywhere
ssht user@work.example.com

# distinct sessions per project, in parallel
ssht --session backend user@work.example.com
ssht --session frontend user@work.example.com

# ssh options you already use still work
ssht -J bastion -p 2222 -A user@10.0.0.5
```

## Notes

- tmux must run on the **server** — nothing is needed on the client beyond this script.
- Detach with `Ctrl-b d`; the session survives. Re-run `ssht` to pick it back up.
- Session names with a single quote break the remote command (assumed sane; not escaped).

## Similar tools

`ssht` is not the first wrapper to land in a remote tmux session, but it's the smallest with a
real fallback. The trick itself comes from a 2014 Stack Overflow answer
(`ssh -t 'tmux attach || tmux new'`), later simplified with tmux's built-in `tmux new -A`
(which `ssht` uses). Tools we found while building this:

| Tool | What it does | Differs from ssht |
|------|--------------|--------------------|
| [brejoc/ssht](https://github.com/brejoc/ssht) | Same goal: attach/create a remote tmux session over ssh | Makefile-packaged with a brew tap; unmaintained ~3 years; no fallback when tmux is absent |
| [wheatdog/sshmux](https://github.com/wheatdog/sshmux) | Bash wrapper giving persistent ssh via tmux | Adds `-s`/`--ls`/`--tmux-path` flags and client-side reconnect; breaks ssh's own `-s` flag; requires tmux (no plain-shell fallback) |
| [shabane/ssht](https://github.com/shabane/ssht) | Go TUI listing hosts into synchronized tmux panes | Different purpose (multi-host pane sync), not single-session attach |
| [tmux-ssh](https://github.com/tmux-ssh/tmux-ssh) | Spawns synchronized SSH sessions in one tmux window | Different purpose (type once, execute everywhere) |
| byobu / tmuxinator / tmux-resurrect | Session managers & persistence helpers | Bigger surface: config files, YAML layouts, plugin dependencies |

`ssht` deliberately does one thing: one command, zero config, everything else forwarded
verbatim to ssh, and a graceful degrade to a plain shell on hosts without tmux.

## License

MIT

<!-- funding:start -->
## Support

If this project is useful to you, please consider supporting my open-source work.

[![GitHub Sponsors](https://img.shields.io/badge/GitHub_Sponsors-Sponsor-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/brunofin)

[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/brunofin)

[![Wise](https://img.shields.io/badge/Wise-Donate-9FE870?style=for-the-badge&logo=wise&logoColor=163300)](https://wise.com/pay/me/brunof24)

[![Pix](https://img.shields.io/badge/Pix-Donate-32BCAD?style=for-the-badge&logo=pix&logoColor=white)](https://nubank.com.br/cobrar/3164y/6ae4922e-9b97-4445-ba66-3cbcd0bd74a3)
<!-- funding:end -->
