#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

python_bin="${PYTHON:-python3}"
if ! "$python_bin" -c 'import json' >/dev/null 2>&1; then
  python_bin="/usr/bin/python3"
fi

"$python_bin" - <<'PY'
import json
from pathlib import Path

def load(path: str):
    with Path(path).open(encoding="utf-8") as handle:
        return json.load(handle)

manifest = load("plugin.json")
compatibility_manifest = load(".codex-plugin/plugin.json")
apps = load(".app.json")
marketplace = load(".agents/plugins/marketplace.json")

assert manifest["name"] == "bugfender"
assert compatibility_manifest["name"] == manifest["name"]
assert manifest["extensions"]["com.openai"]["apps"] == "./.app.json"
assert apps["apps"]["bugfender"]["id"] == "asdk_app_6abe2c470608819180418a63e64b8551"
assert marketplace["plugins"][0]["source"]["path"] == "./"
PY

for path in \
  skills/bugfender/SKILL.md \
  skills/bugfender-sdk-setup/SKILL.md \
  assets/icon.png; do
  test -f "$path" || {
    printf 'Missing required plugin file: %s\n' "$path" >&2
    exit 1
  }
done

printf 'Bugfender plugin package is valid.\n'
