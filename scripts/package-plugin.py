#!/usr/bin/env python3
import hashlib
import json
import shutil
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
version = json.loads((ROOT / "plugin.json").read_text(encoding="utf-8"))["version"]
archive = ROOT / "dist" / f"bugfender-plugin-{version}.zip"
staging = ROOT / "dist" / "bugfender-plugin"
files: dict[str, Path] = {}


def add_file(source: Path, destination: str) -> None:
    files[destination] = source


def add_tree(source: Path, destination: str) -> None:
    for path in source.rglob("*"):
        if path.is_file():
            relative = path.relative_to(source).as_posix()
            add_file(path, f"{destination}/{relative}")


add_file(ROOT / "plugin.json", "plugin.json")
add_file(ROOT / "mcp.json", "mcp.json")
add_file(ROOT / "claude-directory" / ".mcp.json", ".mcp.json")
add_file(
    ROOT / "claude-directory" / ".claude-plugin" / "plugin.json",
    ".claude-plugin/plugin.json",
)
add_tree(ROOT / ".codex-plugin", ".codex-plugin")
add_tree(ROOT / "claude-directory" / "skills", "skills")
add_tree(ROOT / "assets", "assets")
for skill in ("bugfender", "bugfender-sdk-setup"):
    add_file(
        ROOT / "openai-agents" / skill / "openai.yaml",
        f"skills/{skill}/agents/openai.yaml",
    )

archive.parent.mkdir(exist_ok=True)
if staging.exists():
    shutil.rmtree(staging)
for relative, source in files.items():
    destination = staging / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)

with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as output:
    for relative in sorted(files):
        path = files[relative]
        info = zipfile.ZipInfo(relative, date_time=(2026, 1, 1, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        info.external_attr = (0o100644 & 0xFFFF) << 16
        output.writestr(info, path.read_bytes(), compresslevel=9)

digest = hashlib.sha256(archive.read_bytes()).hexdigest()
checksum = archive.with_suffix(archive.suffix + ".sha256")
checksum.write_text(f"{digest}  {archive.name}\n", encoding="utf-8")
print(f"Created {archive.relative_to(ROOT)}")
print(f"SHA-256: {digest}")
