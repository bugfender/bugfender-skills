#!/usr/bin/env python3
import hashlib
import json
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
version = json.loads((ROOT / "plugin.json").read_text(encoding="utf-8"))["version"]
archive = ROOT / "dist" / f"bugfender-plugin-{version}.zip"
roots = ["plugin.json", "mcp.json", ".mcp.json", ".claude-plugin", ".codex-plugin", "skills", "assets"]
files = []
for name in roots:
    path = ROOT / name
    files.extend([path] if path.is_file() else [item for item in path.rglob("*") if item.is_file()])

archive.parent.mkdir(exist_ok=True)
with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as output:
    for path in sorted(files, key=lambda item: item.relative_to(ROOT).as_posix()):
        relative = path.relative_to(ROOT).as_posix()
        info = zipfile.ZipInfo(relative, date_time=(2026, 1, 1, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        info.external_attr = (0o100644 & 0xFFFF) << 16
        output.writestr(info, path.read_bytes(), compresslevel=9)

digest = hashlib.sha256(archive.read_bytes()).hexdigest()
checksum = archive.with_suffix(archive.suffix + ".sha256")
checksum.write_text(f"{digest}  {archive.name}\n", encoding="utf-8")
print(f"Created {archive.relative_to(ROOT)}")
print(f"SHA-256: {digest}")
