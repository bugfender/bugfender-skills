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
claude_manifest = load(".claude-plugin/plugin.json")
mcp = load("mcp.json")
codex_mcp = load(".mcp.json")
marketplace = load(".agents/plugins/marketplace.json")

assert manifest["name"] == "bugfender"
assert compatibility_manifest["name"] == manifest["name"]
assert compatibility_manifest["mcpServers"] == "./.mcp.json"
assert claude_manifest["name"] == manifest["name"]
assert claude_manifest["displayName"] == "Bugfender"
assert claude_manifest["mcpServers"] == "./.mcp.json"
assert claude_manifest["skills"] == "./skills/"
assert claude_manifest["license"] == "Apache-2.0"
assert claude_manifest["metadata"]["company"] == "Bugfender"
assert claude_manifest["metadata"]["longDescription"]
assert mcp["mcpServers"]["bugfender"]["url"] == "https://mcp.bugfender.com/mcp"
assert codex_mcp["mcpServers"]["bugfender"]["url"] == "https://mcp.bugfender.com/mcp"
interface = manifest["extensions"]["com.openai"]["interface"]
assert len(interface["displayName"]) <= 30
assert len(interface["shortDescription"]) <= 30
assert interface["supportURL"] == "https://docs.bugfender.com/"
review = manifest["extensions"]["com.openai"]["review"]["test_cases"]
assert len(review["positive"]) == 5
assert len(review["negative"]) == 3
assert marketplace["plugins"][0]["source"]["path"] == "./"
PY

for path in \
  skills/bugfender/SKILL.md \
  skills/bugfender-sdk-setup/SKILL.md \
  .claude-plugin/plugin.json \
  mcp.json \
  .mcp.json \
  assets/icon.png; do
  test -f "$path" || {
    printf 'Missing required plugin file: %s\n' "$path" >&2
    exit 1
  }
done

printf 'Bugfender plugin package is valid.\n'
