# React Native

Use this reference after detecting a React Native or Expo project.

## Detect

Check:

- `package.json` for `react-native` or `expo`
- `app.json`, `app.config.js`, or `app.config.ts`
- entry file such as `index.js`, `index.ts`, `App.js`, or `App.tsx`
- existing `@bugfender/rn-bugfender` dependency
- existing `Bugfender.init` calls

Decide whether the repo is:

- bare React Native
- Expo with prebuild/native projects

Remember: the native Bugfender module does not work in Expo Go.

## Minimum setup

Install:

```bash
pnpm add @bugfender/rn-bugfender @bugfender/sdk @bugfender/common
```

For Expo, run:

```bash
npx expo prebuild
```

Initialize at the top of the earliest entry file, before rendering:

```ts
import { Bugfender } from "@bugfender/rn-bugfender";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

Helpful defaults when appropriate:

```ts
Bugfender.init({
  appKey: "{APP_KEY}",
  overrideConsoleMethods: true,
  registerErrorHandler: true,
  logUIEvents: true,
});
```

## Integration points

- dependency file: `package.json`
- bootstrap file: `index.js`, `index.ts`, `App.tsx`, or similar
- Expo follow-up: prebuild and native run command

## Hands-off defaults

- initialize before components mount
- keep setup in the entry file rather than spreading it through hooks
- if Expo is detected, tell the developer they need a native build, not Expo Go
- for bare RN, rely on autolinking on modern React Native

## Verification

After init:

```ts
Bugfender.log("Bugfender initialized");
Bugfender.sendIssue("Integration test", "Verifying Bugfender SDK");
```

If logs do not appear quickly, force an upload:

```ts
Bugfender.forceSendOnce();
```

## Common pitfalls

- trying to use the module inside Expo Go
- forgetting `expo prebuild`
- initialization happens after app render instead of before it
- native rebuild not run after dependency installation
