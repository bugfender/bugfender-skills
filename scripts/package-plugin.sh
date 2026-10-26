#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./scripts/validate-plugin.sh

python_bin="${PYTHON:-python3}"
if ! "$python_bin" -c 'import json' >/dev/null 2>&1; then
  python_bin="/usr/bin/python3"
fi

version="$({ "$python_bin" - <<'PY'
import json
with open("plugin.json", encoding="utf-8") as handle:
    print(json.load(handle)["version"])
PY
} 2>/dev/null)"
archive="dist/bugfender-plugin-${version}.zip"

mkdir -p dist
rm -f "$archive"
/usr/bin/zip -qr "$archive" \
  plugin.json \
  mcp.json \
  .mcp.json \
  .claude-plugin \
  .codex-plugin \
  skills \
  assets

printf 'Created %s\n' "$archive"
