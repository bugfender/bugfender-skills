# Ionic

Use this reference after detecting an Ionic app, especially one backed by Capacitor.

## Detect

Check:

- `ionic.config.json`
- `capacitor.config.*`
- `src/main.ts`

## Minimum setup

Install:

```bash
npm install @bugfender/capacitor @bugfender/sdk @bugfender/common
npx cap sync
```

Initialize in `main.ts`:

```ts
import { Bugfender } from "@bugfender/capacitor";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

## Integration points

- dependency file: `package.json`
- Capacitor sync step: `npx cap sync`
- bootstrap: `src/main.ts`

## Optional capabilities

- Browser/UI logging, error handling, and platform-specific options should follow the chosen feature set.

## Verification

After init resolves, log one startup message:

```ts
Bugfender.log("Bugfender initialized");
```

