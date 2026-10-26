#!/usr/bin/env python3
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PACKAGE_FILES = [
    ROOT / "plugin.json", ROOT / "mcp.json", ROOT / ".mcp.json",
    ROOT / ".codex-plugin/plugin.json", ROOT / ".claude-plugin/plugin.json",
    *sorted((ROOT / "skills").rglob("*")), *sorted((ROOT / "assets").glob("*")),
]

def fail(message: str) -> None:
    print(f"validation error: {message}", file=sys.stderr)
    raise SystemExit(1)

def load(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as error:
        fail(f"{path.relative_to(ROOT)} is not valid JSON: {error}")

claude = load(ROOT / ".claude-plugin/plugin.json")
schema = load(ROOT / "schemas/claude-plugin.schema.json")
try:
    import jsonschema
except ImportError:
    fail("install validation dependencies with: python3 -m pip install -r requirements-dev.txt")
jsonschema.Draft202012Validator(schema, format_checker=jsonschema.FormatChecker()).validate(claude)

manifests = [load(ROOT / name) for name in ["plugin.json", ".codex-plugin/plugin.json"]]
versions = {claude["version"], *(manifest["version"] for manifest in manifests)}
names = {claude["name"], *(manifest["name"] for manifest in manifests)}
if len(versions) != 1 or len(names) != 1:
    fail(f"Claude, Codex, and portable manifest names/versions must match: names={names}, versions={versions}")

for name in [".mcp.json", "mcp.json"]:
    mcp = load(ROOT / name)
    server = mcp.get("mcpServers", {}).get("bugfender", {})
    if server.get("url") != "https://mcp.bugfender.com/mcp":
        fail(f"{name} must use the production Bugfender MCP URL")
    if set(server) - {"type", "url"}:
        fail(f"{name} contains unsupported or credential-bearing MCP fields")
    if name == ".mcp.json" and server.get("type") != "http":
        fail(".mcp.json must declare the remote server type as http")

for skill_file in sorted((ROOT / "skills").glob("*/SKILL.md")):
    text = skill_file.read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if not match:
        fail(f"{skill_file.relative_to(ROOT)} is missing YAML frontmatter")
    fields = dict(re.findall(r"^([a-z][a-z0-9-]*):\s*(.+)$", match.group(1), re.MULTILINE))
    if fields.get("name") != skill_file.parent.name or not fields.get("description"):
        fail(f"{skill_file.relative_to(ROOT)} must declare its directory name and a description")

required_cases = {
    "find-applications", "investigate-issue", "search-logs", "inspect-devices",
    "update-issue-status", "sdk-setup", "disconnected-connector", "insufficient-scope",
}
case_dirs = {path.parent.name for path in (ROOT / "evals").glob("*/prompt.md")}
if case_dirs != required_cases:
    fail(f"eval cases do not match the required workflow set: {case_dirs}")
for case in sorted(required_cases):
    case_dir = ROOT / "evals" / case
    prompt = (case_dir / "prompt.md").read_text(encoding="utf-8")
    if not prompt.startswith("---\n") or not list((case_dir / "graders").glob("*.md")):
        fail(f"eval case {case} needs prompt frontmatter and at least one grader")

local_link = re.compile(r"\[[^]]*]\((?!https?://|mailto:|#)([^)]+)\)")
for markdown in sorted([ROOT / "README.md", *(ROOT / "skills").rglob("*.md")]):
    for target in local_link.findall(markdown.read_text(encoding="utf-8")):
        clean = target.split("#", 1)[0]
        if clean and not (markdown.parent / clean).resolve().is_file():
            fail(f"broken relative link in {markdown.relative_to(ROOT)}: {target}")

forbidden_url = re.compile(r"https?://(?:localhost|127\.0\.0\.1|[^/]*(?:staging|trycloudflare|ngrok)[^/]*)", re.I)
secret = re.compile(r"(?i)(?:api[_-]?key|access[_-]?token|refresh[_-]?token|client[_-]?secret|authorization)\s*[=:]\s*['\"]?[A-Za-z0-9._-]{12,}")
for path in PACKAGE_FILES:
    if not path.is_file() or path.suffix.lower() in {".png", ".zip"}:
        continue
    text = path.read_text(encoding="utf-8")
    if forbidden_url.search(text):
        fail(f"environment-specific URL found in package file {path.relative_to(ROOT)}")
    if secret.search(text):
        fail(f"possible embedded secret found in package file {path.relative_to(ROOT)}")

print("Schema, MCP, skill layout, link, secret, URL, and version validation passed.")
