#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BIN_DIR="$HOME/.local/bin"

usage() {
  cat <<'USAGE'
Usage:
  ./scripts/install-user-tools.sh [--bin-dir DIR]

Options:
  --bin-dir DIR  Install symlinks into DIR instead of ~/.local/bin
  -h, --help     Show this help
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --bin-dir)
      shift
      if [ "$#" -eq 0 ]; then
        echo "Missing value for --bin-dir" >&2
        exit 1
      fi
      BIN_DIR="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

mkdir -p "$BIN_DIR"
ln -sfn "$SCRIPT_DIR/add-ssh-key" "$BIN_DIR/add-ssh-key"

printf 'Installed add-ssh-key -> %s/add-ssh-key\n' "$BIN_DIR"

case ":$PATH:" in
  *:"$BIN_DIR":*)
    ;;
  *)
    printf 'Add %s to PATH if it is not already exported in your shell config.\n' "$BIN_DIR"
    ;;
esac
