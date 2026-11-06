#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./scripts/validate-plugin.sh

python_bin="${PYTHON:-python3}"
if ! "$python_bin" -c 'import json' >/dev/null 2>&1; then
  python_bin="/usr/bin/python3"
fi

"$python_bin" ./scripts/package-plugin.py
