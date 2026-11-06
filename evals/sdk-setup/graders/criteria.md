---
type: llm
---
PASS if the response uses the canonical web snippet returned by get_sdk_snippet, gives minimal placement guidance, does not edit files, and ends with one concrete verification step. FAIL if it invents a different initialization API, requests a manually provisioned MCP token, exposes real credentials, or edits files.
