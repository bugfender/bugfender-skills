# Android

Use this reference after detecting an Android project.

## Detect

Check:

- `app/build.gradle.kts` or `app/build.gradle`
- an existing `Application` subclass under `src/main`
- `android:name` in `app/src/main/AndroidManifest.xml`
- existing `Bugfender.init` calls

Prefer updating an existing `Application` class over creating a new one.

## Minimum setup

Add the dependency under the app module dependencies:

```kotlin
implementation("com.bugfender.sdk:android:3.+")
```

or Groovy:

```groovy
implementation 'com.bugfender.sdk:android:3.+'
```

Initialize in the `Application` class `onCreate()`:

```kotlin
Bugfender.init(this, "{APP_KEY}", BuildConfig.DEBUG, true)
Bugfender.enableCrashReporting()
Bugfender.enableUIEventLogging(this)
Bugfender.enableLogcatLogging()
```

If you create a new `Application` class, register it in `AndroidManifest.xml` with `android:name`.

## Integration points

- dependency file: `app/build.gradle.kts` or `app/build.gradle`
- bootstrap: existing `Application` class
- fallback bootstrap: create `App.kt` or `App.java`
- manifest registration: `app/src/main/AndroidManifest.xml`

## Hands-off defaults

- choose Kotlin syntax for `.kts`, Groovy syntax for `.gradle`
- keep initialization in one place
- only enable optional capabilities after the feature set is confirmed
- `enableCrashReporting()` is usually the first optional feature to offer
- keep `enableLogcatLogging()` Android-specific and opt-in
- use `enableUIEventLogging()` only when the user asked for it or the setup explicitly includes it

## Verification

Add one test log or issue after init and run the app:

```kotlin
Bugfender.d("Bugfender", "SDK initialized")
Bugfender.sendIssue("Integration test", "Verifying Bugfender SDK")
```

## Common pitfalls

- missing `android:name` on `<application>`
- init added outside `Application.onCreate()`
- dependency added to the wrong Gradle module
- no rebuild/sync after Gradle change
