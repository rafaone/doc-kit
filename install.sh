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
# --json leaves a single config in ~/.config/opencode: a second one in
# ~/.opencode would be merged on top and could undo the model pinning.
# STRATA_URL (e.g. http://192.168.25.100:8080) sets the Strata address in it.
if [ "${1:-}" = "--json" ]; then
  stamp=$(date +%Y%m%d%H%M%S)
  [ -f "$OC/opencode.json" ] && cp -v "$OC/opencode.json" "$OC/opencode.json.bak.$stamp"
  [ -f "$HOME/.opencode/opencode.json" ] && mv -v "$HOME/.opencode/opencode.json" "$HOME/.opencode/opencode.json.bak.$stamp"
  cp -v opencode/opencode.json "$OC/opencode.json"
  if [ -n "${STRATA_URL:-}" ]; then
    sed -i "s|http://127.0.0.1:8080/v1|${STRATA_URL%/}/v1|" "$OC/opencode.json"
  fi
  grep -n '"baseURL"' "$OC/opencode.json"
elif [ -f "$OC/opencode.json" ] && [ -f "$HOME/.opencode/opencode.json" ]; then
  echo "WARNING: two opencode configs (~/.config/opencode and ~/.opencode). Run ./install.sh --json to keep one."
elif [ ! -f "$OC/opencode.json" ] && [ ! -f "$HOME/.opencode/opencode.json" ]; then
  cp -v opencode/opencode.json "$OC/opencode.json"
else
  echo "opencode.json already exists: kept. Use ./install.sh --json to replace it (with a backup)."
fi

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "Add ~/.local/bin to your PATH to use 'doc-loop'.";; esac
echo "Done. In opencode: /doc-plan + /doc-next (dev docs), /doc-pre-manual-plan + /doc-pre-manual (pre-manual), /small-steps (code changes)."
