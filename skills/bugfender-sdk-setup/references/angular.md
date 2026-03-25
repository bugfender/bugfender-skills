# Angular

Use this reference after detecting an Angular app.

## Detect

Check:

- `angular.json`
- `src/app/app.module.ts`
- `src/main.ts`

Prefer `src/app/app.module.ts` as the Bugfender init location unless the repo already centralizes bootstrapping elsewhere.

## Minimum setup

Install:

```bash
npm i @bugfender/sdk
```

Initialize in `src/app/app.module.ts`:

```ts
import { Bugfender } from "@bugfender/sdk";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

## Integration points

- dependency file: `package.json`
- bootstrap: `src/app/app.module.ts`
- optional crash wiring: custom Angular `ErrorHandler`

## Optional capabilities

- Crash reporting needs a custom Angular `ErrorHandler` that forwards errors with `Bugfender.sendCrash(...)`.
- Browser/UI logging should only be enabled if the chosen feature set includes them.

## Verification

After initialization, emit one test log from a known component constructor or startup path:

```ts
Bugfender.log("Bugfender initialized");
```

