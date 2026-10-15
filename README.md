# `@bugfender/skills`

Bugfender plugin and companion skills for ChatGPT, Codex, Cursor, and Claude Code.

## Included Skills

- `skills/bugfender`: investigate crashes, issues, feedback, devices, and logs through the Bugfender MCP server
- `skills/bugfender-sdk-setup`: detect the target platform, fetch the canonical Bugfender SDK snippet, and adapt setup steps to a real repository

## Requirements

- the Bugfender MCP server from [`bugfender/bugfender-mcp`](https://github.com/bugfender/bugfender-mcp)
- a client that supports installing skills from GitHub

## Plugin Package

The repository root is a distributable Bugfender plugin package. It contains:

- the Bugfender investigation and SDK setup skills
- the registered Bugfender staging MCP connection
- OpenAI display metadata, starter prompts, legal URLs, and icon
- a repo-local marketplace entry for ChatGPT and Codex testing

The registered staging connection is `plugin_asdk_app_6abe2c470608819180418a63e64b8551`. OpenAI plugin manifests store its mapped application ID as `asdk_app_6abe2c470608819180418a63e64b8551` in `.app.json`.

Validate the package before installing it:

```bash
./scripts/validate-plugin.sh
```

Create the uploadable archive:

```bash
./scripts/package-plugin.sh
```

The archive is written to `dist/bugfender-plugin-1.0.0.zip`.

### Install from the local marketplace

From the repository root, add the marketplace and install the plugin:

```bash
codex plugin marketplace add .
codex plugin add bugfender@bugfender-local
```

Restart the ChatGPT desktop app after the first marketplace installation. Open **Plugins**, select **Bugfender Local**, install **Bugfender**, and complete the OAuth connection when prompted.

To refresh an existing local installation after changing this repository:

```bash
codex plugin marketplace upgrade bugfender-local
```

### Smoke test

Start a fresh ChatGPT or Codex task and run these prompts in order:

1. `Use Bugfender to tell me who I am.`
2. `List my Bugfender apps.`
3. `Investigate the most important Bugfender issue from the last 24 hours without changing it.`
4. In a disposable sample repository: `Use the Bugfender SDK setup skill to detect this project's platform and show the minimum setup plan. Do not edit files.`

Confirm that OAuth linking completes, Bugfender tools are available, investigation remains read-only unless a write is explicitly requested, and the SDK setup skill detects the repository before suggesting changes.

## Install

In the agent chat inside your IDE, run:

```text
Use $skill-installer to install these skills from https://github.com/bugfender/bugfender-skills:
- skills/bugfender
- skills/bugfender-sdk-setup
```

After installation, restart the client and use:

```text
Use $bugfender-sdk-setup to set up Bugfender in this app with the minimum required changes.
```

## Repository Layout

```text
skills/bugfender/              investigation workflow
skills/bugfender-sdk-setup/    SDK onboarding workflow
assets/                        plugin icon
.app.json                      registered Bugfender MCP connection
.codex-plugin/plugin.json      Codex compatibility manifest
.agents/plugins/marketplace.json repo-local test marketplace
plugin.json                    portable plugin manifest
README.md                      installation and usage
```
