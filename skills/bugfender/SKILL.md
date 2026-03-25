---
name: bugfender
description: Investigate Bugfender apps and help onboard apps into Bugfender through the Bugfender MCP server. Use when the user wants to set up the Bugfender SDK with minimal friction, fetch SDK snippets for a platform, triage crashes, issues, feedback, devices, or logs, identify regressions by app version or time range, quantify impact, or produce a concise incident summary with likely cause and next checks.
---

# Bugfender

## Overview

Use this skill to onboard apps into Bugfender and investigate application health through Bugfender MCP. For setup, fetch the SDK snippet and reduce the decision-making burden on the developer. For investigation, start with narrow, high-signal queries, prefer aggregated issue/crash data before raw logs, and end with a short triage summary that explains scope, likely cause, and the next best check.

## Prerequisites

- Confirm the Bugfender MCP server is available before relying on this skill.
- Determine the target app first. If the user did not provide an app, call `list_apps`.
- Narrow the time window early. Avoid broad unbounded searches unless the user explicitly asks for them.

## Workflow

### Step 1: Decide whether this is setup or investigation

- If the user is trying to instrument an app or is not sure whether Bugfender is installed yet, follow the SDK setup path first.
- Otherwise, follow the investigation path.

### SDK setup path

1. Identify the target app and platform.
2. Call `get_sdk_snippet` for that app and platform.
3. Present the smallest actionable setup steps first:
   - where the dependency goes
   - where initialization goes
   - which token or app key is needed
   - any platform-specific follow-up required
4. Keep the developer focused on one copy-paste step at a time.
5. After setup, suggest the next verification step, for example generating a test log or confirming the app appears in Bugfender.

When helping with setup:

- prefer the official snippet over handwritten instructions
- do not overwhelm the developer with optional configuration unless they ask
- mention only the minimum files and code locations they need to touch

### Investigation path

### Step 2: Establish scope

- Identify the app and the question being answered: crash triage, issue trend, feedback theme, device impact, or log search.
- Determine the smallest useful time range.
- If relevant, ask or infer the app version, issue hash, crash hash, device UDID, or text filter.

### Step 3: Prefer aggregation first

Use aggregated tools before raw logs:

- Crashes:
  - `get_crashes`
  - `get_crash_stats`
  - `get_crash_device_stats`
  - `get_crash_details`
- Issues and feedback:
  - `list_issues`
  - `get_issue`
  - `get_issue_stats`
  - `get_issue_device_stats`
  - `get_issue_devices`
  - `get_feedback`

Use these first to answer:

- Which groups are most frequent?
- Did counts spike after a date or version change?
- Which devices or versions are affected?
- Is the problem localized or widespread?

### Step 4: Drill down only after identifying the target

Once you know the relevant group, version, or device:

- Use `search_logs` to inspect raw evidence for the affected app, date range, device, or text pattern.
- Use `count_logs`, `count_devices_with_logs`, `search_devices`, and `count_devices` to size the blast radius.
- Use `get_app`, `get_app_summary`, and `list_app_versions` when app metadata or version context is needed.

Do not start with broad log searches if aggregation can answer the question faster.

### Step 5: Choose the right path

#### Crash investigation

1. Call `get_crashes` for the relevant window.
2. If a specific crash stands out, call `get_crash_details`.
3. Use `get_crash_stats` to confirm trend and `get_crash_device_stats` to quantify affected devices.
4. If needed, inspect logs around the affected version, device, or time range.

#### Issue or feedback investigation

1. Call `list_issues` or `get_feedback` with the smallest relevant window.
2. Use `get_issue_stats` and `get_issue_device_stats` to quantify trend and reach.
3. Call `get_issue` for the selected hash.
4. If needed, call `get_issue_devices` to inspect affected devices and then drill into logs.

#### App health summary

1. Call `get_app_summary`.
2. If anomalies appear, branch into the crash or issue workflow above.

## Output expectations

End with a concise summary that includes:

- for setup: the exact next code change or verification step
- What you checked
- What is affected
- Evidence: key counts, versions, hashes, or date windows
- Best current hypothesis
- The next best follow-up check

If the data is inconclusive, say so directly and state what is missing.

## Investigation defaults

- Prefer RFC3339 date ranges.
- Keep searches scoped to one app unless the user explicitly wants cross-app analysis.
- Prefer the newest relevant version range when hunting regressions.
- Treat `get_issue.issue_id` as the aggregation hash, not a legacy issue UUID.
- Mention when you infer a cause from correlated data rather than direct proof.

## Example requests

- Help me set up Bugfender in this iOS app with the minimum changes.
- Fetch the Bugfender SDK snippet for Android and tell me exactly where it goes.
- Investigate the top crashes in this app during the last 24 hours.
- Compare issue volume before and after version `123`.
- Summarize the main user feedback themes this week.
- Find which devices are affected by this issue hash.
- Check whether this spike is limited to one app version or OS version.
