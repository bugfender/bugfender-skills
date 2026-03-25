# Flutter

Use this reference after detecting a Flutter app.

## Detect

Check:

- `pubspec.yaml`
- `lib/main.dart`

Prefer `lib/main.dart` as the integration point.

## Minimum setup

Add the dependency in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_bugfender: ^2.3.0
```

Then run:

```bash
flutter pub get
```

Initialize in `lib/main.dart` and wrap startup with `handleUncaughtErrors(...)`:

```dart
await FlutterBugfender.init("{APP_KEY}");
```

## Integration points

- dependency file: `pubspec.yaml`
- bootstrap: `lib/main.dart`

## Optional capabilities

- Confirm whether to enable:
  - `enableCrashReporting`
  - `enableUIEventLogging`
  - `enableAndroidLogcatLogging`
- Custom `apiUri` and `baseUri` are only needed for non-default environments.

## Verification

Emit one test log after initialization:

```dart
FlutterBugfender.log("Bugfender initialized");
```

