# Web

Use this reference after detecting a web app, plain JavaScript app, or frontend framework app that should use the web SDK.

## Detect

Check:

- `package.json`
- `package-lock.json`, `pnpm-lock.yaml`, or `yarn.lock`
- existing `@bugfender/sdk` dependency
- existing `Bugfender.init` calls
- bootstrap entry such as `src/main.ts`, `src/index.tsx`, `src/index.js`, or `index.html`

Prefer the project’s existing package manager.

## Minimum setup

Bundler path:

```bash
pnpm add @bugfender/sdk
```

Equivalent commands with npm or yarn are fine if the repo already uses them.

Initialize as early as possible in the app bootstrap:

```ts
import { Bugfender } from "@bugfender/sdk";

Bugfender.init({
  appKey: "{APP_KEY}",
});
```

Useful low-friction options when appropriate:

```ts
Bugfender.init({
  appKey: "{APP_KEY}",
  overrideConsoleMethods: true,
  registerErrorHandler: true,
  logBrowserEvents: true,
  logUIEvents: true,
});
```

For plain HTML with no bundler, load the CDN script before the app code and initialize from the global `Bugfender`.

## Integration points

- dependency file: `package.json`
- bootstrap file: framework entrypoint or earliest app startup file
- config/env file only if the repo already centralizes runtime keys there

## Hands-off defaults

- prefer direct bootstrap initialization over creating a wrapper abstraction
- initialize before any other logging
- use the existing package manager instead of introducing a new one
- avoid CDN setup unless the repo is clearly non-bundled

## Verification

After init:

```ts
Bugfender.log("Bugfender initialized");
Bugfender.sendIssue("Integration test", "Verifying Bugfender SDK");
```

## Common pitfalls

- init added too late in the bootstrap path
- dependency installed with the wrong package manager for the repo
- console logs expected without `overrideConsoleMethods: true`
- unhandled browser errors expected without `registerErrorHandler: true`
