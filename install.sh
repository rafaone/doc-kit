#!/usr/bin/env bash
# Installs the kit once, globally: it applies to every repository.
set -eu
cd "$(dirname "$0")"
OC="$HOME/.config/opencode"
mkdir -p "$OC/agent" "$OC/command" "$HOME/.local/bin"
cp -v opencode/agent/*.md "$OC/agent/"
cp -v opencode/command/*.md "$OC/command/"
install -v -m 755 doc-loop.sh "$HOME/.local/bin/doc-loop"
install -v -m 755 pre-manual-check.sh "$HOME/.local/bin/pre-manual-check"
install -v -m 755 doc-migrate.sh "$HOME/.local/bin/doc-migrate"

# opencode.json: never overwrites yours silently; backs it up before replacing.
if [ "${1:-}" = "--json" ]; then
  for f in "$OC/opencode.json" "$HOME/.opencode/opencode.json"; do
    [ -f "$f" ] && cp -v "$f" "$f.bak.$(date +%Y%m%d%H%M%S)"
  done
  cp -v opencode/opencode.json "$OC/opencode.json"
elif [ ! -f "$OC/opencode.json" ] && [ ! -f "$HOME/.opencode/opencode.json" ]; then
  cp -v opencode/opencode.json "$OC/opencode.json"
else
  echo "opencode.json already exists: kept. Use ./install.sh --json to replace it (with a backup)."
fi

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "Add ~/.local/bin to your PATH to use 'doc-loop'.";; esac
echo "Done. In opencode: /doc-plan + /doc-next (dev docs), /doc-pre-manual-plan + /doc-pre-manual (pre-manual), /small-steps (code changes)."
