#!/bin/sh
# ssht installer — copies the ssht script into $PREFIX (default ~/.local/bin).
set -eu

prefix="${PREFIX:-$HOME/.local/bin}"
mkdir -p "$prefix"
script_dir=$(cd "$(dirname "$0")" && pwd)

install -m 755 "$script_dir/ssht" "$prefix/ssht"
echo "ssht installed to $prefix/ssht"

case ":$PATH:" in
  *":$prefix:"*) ;;
  *) echo "note: $prefix is not on your PATH" ;;
esac
