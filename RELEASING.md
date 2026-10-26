# Releasing the Bugfender plugin

Claude, Codex, and portable manifests share one version and one `skills/` tree. Never copy or fork skill content per client.

1. Update the version in `plugin.json`, `.codex-plugin/plugin.json`, and `.claude-plugin/plugin.json` in the same change.
2. Install validation dependencies with `python3 -m pip install -r requirements-dev.txt` and install the current Claude Code CLI.
3. Run `./scripts/validate-release.sh`.
4. Run deterministic plugin evaluations with `claude plugin eval . --runs 1 --ablation none --no-publish`. Before a public release, repeat with the default three runs.
5. Run `./scripts/package-plugin.sh` twice and confirm the printed SHA-256 digest is identical.
6. Inspect the ZIP. It must contain both manifests, the shared `.mcp.json`, shared skills, references, and assets; it must not contain eval results, credentials, local URLs, or build-machine metadata.
7. Test the ZIP with `claude --plugin-dir dist/bugfender-plugin-<version>.zip` and the repository through the Codex local marketplace.
8. Commit, tag, and attach the ZIP plus its `.sha256` file to the release. Do not publish one client package from a different commit than the other.

CI always runs deterministic validation. The model-backed evaluation job runs when `ANTHROPIC_API_KEY` is configured and can also be started manually.
