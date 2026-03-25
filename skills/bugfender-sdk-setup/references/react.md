# React

Use this reference after detecting a React web app.

## Detect

Check:

- `package.json` for React dependencies
- `src/index.js`, `src/index.tsx`, `src/main.jsx`, or `src/main.tsx`

Prefer the main app bootstrap file before the first render call.

## Minimum setup

Install:

```bash
npm i @bugfender/sdk
```

Initialize in the app entrypoint before `ReactDOM.render(...)` or `createRoot(...).render(...)`:

```ts
import { Bugfender } from "@bugfender/sdk";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

## Integration points

- dependency file: `package.json`
- bootstrap: `src/index.*` or `src/main.*`

## Optional capabilities

- Browser/UI logging should be enabled only if requested.
- Crash reporting for React web is usually explicit app error handling rather than a one-line native toggle.

## Verification

Emit one startup log:

```ts
Bugfender.log("Bugfender initialized");
```

