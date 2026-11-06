#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
claude_bin="${CLAUDE_BIN:-$(command -v claude || true)}"
cd "$repo_root"

if [[ -z "$claude_bin" ]]; then
  printf 'Claude Code is required. Set CLAUDE_BIN or add claude to PATH.\n' >&2
  exit 1
fi

test_root="$(mktemp -d "${TMPDIR:-/tmp}/bugfender-claude-marketplace.XXXXXX")"
config_dir="$test_root/config"
mkdir -p "$config_dir"
plugin_version="$(python3 -c 'import json; print(json.load(open(".claude-plugin/plugin.json"))["version"])' < /dev/null)"

cleanup() {
  find "$test_root" -depth -delete 2>/dev/null || true
}
trap cleanup EXIT

run_claude() {
  CLAUDE_CONFIG_DIR="$config_dir" "$claude_bin" "$@"
}

assert_plugin_state() {
  local expected="$1"
  if [[ "$expected" == "installed" ]]; then
    run_claude plugin list --json | python3 -c '
import json, sys
items = json.load(sys.stdin)
matches = [item for item in items if item.get("id") == "bugfender@bugfender-private"]
if len(matches) != 1:
    raise SystemExit(f"expected one installed Bugfender plugin, found {len(matches)}")
'
  else
    run_claude plugin list --json --available | python3 -c '
import json, sys
catalog = json.load(sys.stdin)
matches = [item for item in catalog.get("available", []) if item.get("pluginId") == "bugfender@bugfender-private"]
if len(matches) != 1:
    raise SystemExit(f"expected one available Bugfender plugin, found {len(matches)}")
'
  fi
}

printf 'Using isolated Claude configuration: %s\n' "$config_dir"
run_claude plugin validate --strict "$repo_root"
run_claude plugin marketplace add "$repo_root" --scope user --json
run_claude plugin marketplace list --json | python3 -c '
import json, sys
items = json.load(sys.stdin)
if not any(item.get("name") == "bugfender-private" for item in items):
    raise SystemExit("Bugfender private marketplace was not registered")
'
assert_plugin_state available

run_claude plugin install bugfender@bugfender-private --scope user --json
assert_plugin_state installed
run_claude plugin list --json | python3 -c '
import json, sys
items = json.load(sys.stdin)
matches = [item for item in items if item.get("id") == "bugfender@bugfender-private"]
if len(matches) != 1:
    raise SystemExit("installed Bugfender plugin was not found")
item = matches[0]
if item.get("version") != sys.argv[1]:
    raise SystemExit(f"unexpected plugin version: {item.get('"'"'version'"'"')}")
if "bugfender" not in item.get("mcpServers", {}):
    raise SystemExit("installed plugin did not register its MCP server")
' "$plugin_version"
details="$(run_claude plugin details bugfender@bugfender-private)"
grep -Fq 'Skills (2)  bugfender, bugfender-sdk-setup' <<<"$details"
grep -Fq 'MCP servers (1)  bugfender' <<<"$details"

run_claude plugin update bugfender@bugfender-private --scope user --json
run_claude plugin uninstall bugfender@bugfender-private --scope user --json
assert_plugin_state available

# Simulate reinstalling after a grant has been revoked. OAuth tokens are owned by
# the MCP client and are deliberately not copied into this isolated test config.
run_claude plugin install bugfender@bugfender-private --scope user --json
assert_plugin_state installed
run_claude plugin uninstall bugfender@bugfender-private --scope user --json
run_claude plugin marketplace remove bugfender-private --json

printf 'Fresh marketplace registration, discovery, install, update, uninstall, and reinstall passed.\n'
printf 'Run the OAuth acceptance checklist in docs/claude-marketplace-testing.md with a real account.\n'
