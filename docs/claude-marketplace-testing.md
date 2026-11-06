# Claude Marketplace Acceptance Testing

Use this checklist before releasing a Bugfender Claude Plugin version. Run the
automated marketplace lifecycle test first:

```bash
./scripts/test-claude-marketplace.sh
```

The automated test verifies marketplace registration, discovery, installation,
MCP registration, update, uninstall, and reinstall in an isolated Claude
configuration. Complete the checks below with a real Bugfender account because
OAuth and client synchronization cannot be validated deterministically in CI.

## Prerequisites

- Use a clean Claude profile or remove any previously installed Bugfender plugin.
- Confirm the plugin manifest, marketplace entry, and release artifact have the
  same version.
- Confirm the production MCP endpoint is reachable.
- Use a disposable Bugfender issue for the write-tool check.

## Fresh installation

1. Add this repository as a Claude marketplace.
2. Confirm that Bugfender appears once in plugin discovery with the expected
   name, description, version, skills, and MCP server.
3. Install the plugin and start a new Claude session.
4. Confirm that the Bugfender MCP server appears and initiates OAuth when first
   used.
5. Complete authorization in Bugfender and confirm that Claude reconnects
   without requiring a manually copied token.

## Skills and tools

Run these prompts in a fresh session:

1. `Use Bugfender to tell me who I am.`
2. `List my Bugfender apps.`
3. `Investigate the most important Bugfender issue from the last 24 hours without changing anything.`
4. `Search recent error logs and summarize recurring messages.`
5. `Inspect the devices affected by this issue.`
6. In a disposable repository: `Start the Bugfender SDK setup workflow and show the plan without editing files.`

Confirm that both Bugfender skills are discoverable, read-only investigation
uses only read tools, tool errors expose no credentials, and responses remain
within the expected result limits.

For the write-tool check, ask Claude to change the disposable issue's status.
Confirm that Claude clearly identifies the state-changing action and gets the
expected confirmation before invoking `update_issue_status`.

## Upgrade

1. Install the previous plugin version.
2. Update the marketplace to the candidate version.
3. Upgrade the plugin and start a new session.
4. Confirm the new version, both skills, the MCP server, and all expected tools
   are available.
5. Confirm that an existing valid OAuth connection still works.

## Disconnect, uninstall, and revocation

1. Disconnect Bugfender from Claude and confirm subsequent tool use requests a
   new authorization.
2. Reconnect, then revoke the grant from Bugfender.
3. Confirm the next tool call fails safely and offers reconnection without
   suggesting manual token copying.
4. Uninstall the plugin and confirm its skills and MCP tools disappear from new
   sessions.
5. Reinstall the plugin after revocation and confirm a fresh OAuth grant restores
   tool access.

## Claude surfaces and synchronization

Where submission preview access is available, verify the plugin in Claude.ai or
Cowork as well as Claude Code. Confirm that the plugin is discoverable on each
supported surface and that account synchronization behaves as documented for
the test account. Record any surface-specific limitation in the release notes.

## Release record

Record the tested plugin version, MCP server version, client versions, test date,
tester, and the result of each section. Do not record authorization codes,
tokens, app keys, or other credentials.
