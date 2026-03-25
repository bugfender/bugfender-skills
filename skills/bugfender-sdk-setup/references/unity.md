# Unity

Use this reference after detecting a Unity project.

## Detect

Check:

- `Packages/manifest.json`
- Unity project folders such as `Assets/`, `Packages/`, and `ProjectSettings/`

## Minimum setup

Install the package from the Unity Package Manager using the git URL:

```text
https://github.com/bugfender/BugfenderSDK-Unity.git
```

Then:

- open `Packages/Bugfender`
- drag the `Bugfender` prefab into the main scene
- set the app key in the Inspector

## Integration points

- package manager: Unity Package Manager
- scene setup: main scene prefab
- configuration: Inspector on the Bugfender prefab

## Optional capabilities

- If custom API or base URLs are required, set them on the Bugfender instance.

## Verification

Use `Bugfender.Log(...)` from a known startup path and confirm the first session appears in Bugfender.

