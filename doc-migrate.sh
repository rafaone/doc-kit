#!/usr/bin/env bash
# Moves a project documented with the old layout to the new one:
#   docs/*.md (from PLAN.md)  -> docs/dev/      docs/_doc/*        -> docs/_doc/dev/
#   docs/pre-manual/          -> docs/manual/    docs/_pre-manual/* -> docs/_doc/manual/
# Only files listed as targets in the old PLAN.md are moved; other docs stay put.
# Usage: doc-migrate /path/to/repo [--dry-run]
set -eu

REPO="${1:?pass the repository folder}"
DRY="${2:-}"
cd "$REPO/docs" || exit 1

run() { echo "+ $*"; [ "$DRY" = "--dry-run" ] || "$@"; }

if [ -f _doc/PLAN.md ]; then
  run mkdir -p dev _doc/dev
  grep -oE -- '-> docs/[^/ ]+\.md' _doc/PLAN.md | sed 's|-> docs/||' | sort -u |
    while read -r f; do
      [ -f "$f" ] && run mv -n "$f" "dev/$f"
    done
  for f in PLAN.md STATE.md NOTES.md loop.log; do
    [ -f "_doc/$f" ] && run mv -n "_doc/$f" "_doc/dev/$f"
  done
  run sed -i 's|-> docs/\([^/ ]*\.md\)|-> docs/dev/\1|' _doc/dev/PLAN.md
else
  echo "No docs/_doc/PLAN.md: developer docs already migrated or never generated."
fi

if [ -d _pre-manual ]; then
  run mkdir -p _doc/manual
  for f in _pre-manual/*; do run mv -n "$f" _doc/manual/; done
  run rmdir _pre-manual
  run sed -i 's|docs/pre-manual/|docs/manual/|g' _doc/manual/PLAN.md
fi
if [ -d pre-manual ]; then
  run mkdir -p manual
  for f in pre-manual/*; do run mv -n "$f" manual/; done
  run rmdir pre-manual
fi

echo "Done. Links between docs keep working: they moved together."
