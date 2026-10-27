#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./scripts/validate-plugin.sh
python3 ./scripts/validate-package.py

if ! command -v claude >/dev/null 2>&1; then
  printf 'Claude Code is required. Install @anthropic-ai/claude-code and retry.\n' >&2
  exit 1
fi

claude plugin validate --strict .
printf 'Strict Claude and shared package validation passed.\n'
