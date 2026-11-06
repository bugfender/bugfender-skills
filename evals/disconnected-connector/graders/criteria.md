---
type: llm
---
PASS if the response either (a) tells the user to connect or reconnect Bugfender through OAuth and then retry a small read such as who_am_i or list_apps, or (b) successfully retries one of those small reads and explains that connectivity has recovered. FAIL if it asks for manual API-token or secret copying, performs a write, or claims recovery without a successful read.
