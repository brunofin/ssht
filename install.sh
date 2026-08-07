#!/bin/sh
# ssht installer — downloads the ssht script into $PREFIX (default ~/.local/bin).
set -eu

prefix="${PREFIX:-$HOME/.local/bin}"
url="https://raw.githubusercontent.com/brunofin/ssht/main/ssht"

mkdir -p "$prefix"
curl -fsSL "$url" -o "$prefix/ssht"
chmod +x "$prefix/ssht"
echo "ssht installed to $prefix/ssht"

case ":$PATH:" in
  *":$prefix:"*) ;;
  *) echo "note: $prefix is not on your PATH" ;;
esac
