# Vue

Use this reference after detecting a Vue app.

## Detect

Check:

- `package.json` for Vue
- `src/main.ts` or `src/main.js`

Prefer `src/main.ts` or `src/main.js` as the init location.

## Minimum setup

Install:

```bash
npm i @bugfender/sdk
```

Initialize in `src/main.ts` or `src/main.js` before mounting the app:

```ts
import { Bugfender } from "@bugfender/sdk";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

## Integration points

- dependency file: `package.json`
- bootstrap: `src/main.ts` or `src/main.js`
- optional crash wiring: `app.config.errorHandler`

## Optional capabilities

- Crash reporting in Vue usually means wiring `app.config.errorHandler` to `Bugfender.sendCrash(...)`.
- Browser/UI logging should be enabled only when requested.

## Verification

After initialization, emit one test log from startup:

```ts
Bugfender.log("Bugfender initialized");
```

