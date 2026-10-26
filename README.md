# Bugfender Plugin

Bugfender plugin and companion skills for Claude, ChatGPT, Codex, and compatible agent clients.

## Included Skills

- `skills/bugfender`: investigate crashes, issues, feedback, devices, and logs through the Bugfender MCP server
- `skills/bugfender-sdk-setup`: detect the target platform, fetch the canonical Bugfender SDK snippet, and adapt setup steps to a real repository

## Requirements

- the Bugfender MCP server from [`bugfender/bugfender-mcp`](https://github.com/bugfender/bugfender-mcp)
- a client that supports installing skills from GitHub

## Plugin Package

The repository root is a distributable Bugfender plugin package. It contains:

- the Bugfender investigation and SDK setup skills
- the hosted Bugfender MCP connection at `https://mcp.bugfender.com/mcp`
- OpenAI display metadata, starter prompts, legal URLs, and icon
- a repo-local marketplace entry for ChatGPT and Codex testing

The MCP configuration contains no client secret or user token. Compatible clients discover Bugfender OAuth from the protected resource and authorization-server metadata and store the resulting user grant themselves.

Validate the package before installing it:

```bash
./scripts/validate-plugin.sh
```

Create the uploadable archive:

```bash
./scripts/package-plugin.sh
```

The archive is written to `dist/bugfender-plugin-1.0.0.zip`.

For strict validation, evaluations, coordinated versioning, and reproducible release artifacts, see [RELEASING.md](./RELEASING.md).

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

### Install and test with Claude Code

Validate the Claude manifest with a recent Claude Code release:

```bash
claude plugin validate --strict .
```

Load the repository for one development session:

```bash
claude --plugin-dir .
```

Claude loads the two skills as `/bugfender:bugfender` and `/bugfender:bugfender-sdk-setup`. When a Bugfender tool is used for the first time, complete the OAuth connection in the browser. Do not paste manually provisioned tokens into Claude.

Example requests:

1. `Use Bugfender to tell me who I am.`
2. `Investigate the highest-impact crash in the last 24 hours without changing anything.`
3. `Set up the Bugfender SDK in this repository and leave me with one verification step.`

If Claude reports that the connector is unavailable or unauthorized, open the Bugfender MCP connection, complete or repeat OAuth, and retry `who_am_i`. The plugin must not ask for API tokens or client secrets.

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
.claude-plugin/plugin.json     Claude plugin manifest
.agents/plugins/marketplace.json repo-local test marketplace
plugin.json                    portable plugin manifest
README.md                      installation and usage
```
