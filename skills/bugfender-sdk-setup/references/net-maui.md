# .NET MAUI

Use this reference after detecting a .NET MAUI app.

## Detect

Check:

- `.csproj`
- `Platforms/iOS/AppDelegate.cs`
- `Platforms/Android/MainApplication.cs`

## Minimum setup

Install:

```bash
dotnet add package Bugfender.Sdk --version 3.0.0
```

For iOS:

- set linker behavior to `Link Frameworks SDKs Only`
- initialize in `AppDelegate.cs` inside `FinishedLaunching(...)`

For Android:

- initialize in `Platforms/Android/MainApplication.cs`
- create an application class if the project does not already have one

## Integration points

- dependency file: project `.csproj`
- iOS bootstrap: `Platforms/iOS/AppDelegate.cs`
- Android bootstrap: `Platforms/Android/MainApplication.cs`

## Optional capabilities

- Confirm whether to enable native crash reporting, MAUI crash reporting, and UI event logging.
- Custom `apiUri` and `baseUri` are only needed for non-default environments.

## Verification

Emit one startup log or warning through `BugfenderBinding.Instance` and confirm the device URL resolves in Bugfender.

