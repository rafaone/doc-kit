#!/usr/bin/env bash
# Flags lines in pre-manual .md files that look like source code leaks.
# Usage: pre-manual-check FILE_OR_DIR...   (default: docs/manual)
# Exit 0 = clean, 1 = something to review. Run it before pasting anything outside.
set -u

# One pattern per leak type; label shown in the report.
PATTERNS=(
  'code|`'
  'file|\.(py|ts|tsx|js|jsx|java|kt|cs|go|rs|rb|php|sql|json|ya?ml|xml|env|ini|toml|properties|sh)\b'
  'call|\b[A-Za-z_][A-Za-z0-9_]*\(\)'
  'snake_case|\b[a-z][a-z0-9]*_[a-z0-9_]+\b'
  'camelCase|\b[a-z]+[A-Z][A-Za-z0-9]*\b'
  'CONSTANT|\b[A-Z][A-Z0-9]*_[A-Z0-9_]+\b'
  'path|(^|[ (])(\./|\.\./|/)?[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/'
  'url|https?://|localhost|127\.0\.0\.1|:[0-9]{4,5}\b'
  'endpoint|\b(GET|POST|PUT|PATCH|DELETE) /'
)

targets=("$@")
[ ${#targets[@]} -eq 0 ] && targets=(docs/manual)

files=$(find "${targets[@]}" -type f -name '*.md' 2>/dev/null)
[ -z "$files" ] && { echo "No .md files found in: ${targets[*]}"; exit 0; }

hits=0
for f in $files; do
  for p in "${PATTERNS[@]}"; do
    label=${p%%|*}; regex=${p#*|}
    while IFS= read -r line; do
      echo "$f:$line  [$label]"
      hits=$((hits + 1))
    done < <(grep -nE "$regex" "$f")
  done
done

if [ "$hits" -eq 0 ]; then
  echo "clean: no code references found"
else
  echo "$hits line(s) to review: rewrite them in user terms"
  exit 1
fi
