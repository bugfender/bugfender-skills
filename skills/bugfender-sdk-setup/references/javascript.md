# JavaScript Web

Use this reference after detecting a plain JavaScript web app.

## Detect

Check:

- `package.json` for a JS app
- `index.html`
- entry files such as `src/index.js`, `main.js`, or another script loaded by the page

Pick one install path and stick to it: npm or script tag.

## Minimum setup

Preferred when a bundler or `package.json` exists:

```bash
npm install @bugfender/sdk
```

Then initialize in the entrypoint:

```js
import { Bugfender } from "@bugfender/sdk";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

Fallback for static sites:

```html
<script defer src="https://js.bugfender.com/bugfender-v2.js"></script>
```

Then initialize in the app script.

## Integration points

- dependency file: `package.json` if present
- script-tag path: `index.html`
- bootstrap: main JS entrypoint

## Optional capabilities

- `overrideConsoleMethods`, browser event logging, and UI event logging are optional and should only be enabled if requested.

## Verification

Send one startup log:

```js
Bugfender.log("Bugfender initialized");
```

