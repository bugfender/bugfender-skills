#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="${1:-$repo_root/dist/claude-local}"

if [[ -e "$output_dir" ]]; then
  find "$output_dir" -depth -delete
fi
mkdir -p "$output_dir/.claude-plugin"

cp -R "$repo_root/skills" "$output_dir/skills"
cp -R "$repo_root/assets" "$output_dir/assets"
cp "$repo_root/.claude-plugin/plugin.json" "$output_dir/.claude-plugin/plugin.json"
cp "$repo_root/.mcp.local.json" "$output_dir/.mcp.json"
cp "$repo_root/README.md" "$output_dir/README.md"

printf 'Prepared local Claude plugin at %s\n' "$output_dir"
printf 'MCP endpoint: http://localhost:3002/mcp\n'
printf 'Run: claude --plugin-dir %q\n' "$output_dir"
