# Cordova

Use this reference after detecting a Cordova or PhoneGap project.

## Detect

Check:

- `config.xml`
- `cordova` project structure
- `plugins/` and platform folders

## Minimum setup

If iOS is targeted, ensure `config.xml` sets:

```xml
<platform name="ios">
  <preference name="deployment-target" value="10.0" />
</platform>
```

Install the plugin:

```bash
cordova plugin add cordova-plugin-bugfender --variable BUGFENDER_APP_KEY={APP_KEY} --save
```

If custom URLs are required, include:

- `--variable BUGFENDER_BASE_URL='{BASE_URL}'`
- `--variable BUGFENDER_API_URL='{API_URL}'`

## Integration points

- config: `config.xml`
- plugin install path: Cordova CLI
- runtime usage: replace selected `console.log(...)` calls with `Bugfender.log(...)`

## Optional capabilities

- Native crash or feedback behavior should follow the plugin capabilities and the requested feature set.

## Verification

Run on an emulator or real device, not the browser platform, and confirm the first log reaches Bugfender.

