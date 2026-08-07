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
curl -fsSL <url-to-ssht> -o ~/.local/bin/ssht && chmod +x ~/.local/bin/ssht
# or: copy this repo's `ssht` file into your PATH
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

## License

MIT
