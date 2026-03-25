# `@bugfender/skills`

Companion skills for Bugfender workflows in Cursor, Codex, and Claude Code.

## Included Skills

- `skills/bugfender`: investigate crashes, issues, feedback, devices, and logs through the Bugfender MCP server
- `skills/bugfender-sdk-setup`: detect the target platform, fetch the canonical Bugfender SDK snippet, and adapt setup steps to a real repository

## Requirements

- the Bugfender MCP server from [`bugfender/bugfender-mcp`](https://github.com/bugfender/bugfender-mcp)
- a client that supports installing skills from GitHub

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
README.md                      installation and usage
```
