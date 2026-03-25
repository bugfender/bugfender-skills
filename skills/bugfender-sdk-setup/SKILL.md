---
name: bugfender-sdk-setup
description: Set up the Bugfender SDK in an app with minimal developer effort. Use when the user wants hands-off Bugfender onboarding, needs the correct SDK snippet for a platform, wants the agent to detect the project type and integration points, or wants the setup applied directly in the codebase and reduced to one final verification step.
---

# Bugfender SDK Setup

## Overview

Use this skill to make Bugfender SDK onboarding as hands-off as possible. Detect the project type, fetch the right Bugfender SDK snippet, map it to the real repository structure, apply the minimum correct changes when implementation is requested, and leave the developer with only the final verification step.

## Workflow

### Step 1: Detect the target

- Identify the app and platform first.
- If the user did not specify an app, call `list_apps`.
- Detect the repo or framework from the codebase before giving instructions.
- Prefer concrete detection over asking the developer to classify the project.

Typical outcomes:

- Android
- iOS
- React Native
- Flutter
- Unity
- .NET MAUI
- Cordova
- Ionic
- Angular
- React
- Vue
- JavaScript
- jQuery
- Titanium
- Web
- other platform supported by Bugfender snippets

After detection, read only the relevant reference file:

- iOS: `references/ios.md`
- Android: `references/android.md`
- Flutter: `references/flutter.md`
- Unity: `references/unity.md`
- .NET MAUI: `references/net-maui.md`
- Cordova: `references/cordova.md`
- Ionic: `references/ionic.md`
- Angular: `references/angular.md`
- React: `references/react.md`
- Vue: `references/vue.md`
- JavaScript: `references/javascript.md`
- jQuery: `references/jquery.md`
- Titanium: `references/titanium.md`
- Web: `references/web.md`
- React Native: `references/react-native.md`

If the detected platform is not covered there yet, still use `get_sdk_snippet` as the source of truth and follow the same workflow.

### Step 2: Fetch the canonical setup

- Call `get_sdk_snippet` for the chosen app and platform.
- Treat the returned snippet as the source of truth.
- Prefer adapting the official snippet to the repo over inventing a custom setup from memory.

### Step 2.5: Confirm optional capabilities

Before choosing optional SDK features that change the integration shape, ask one short question to lock the feature set.

- Do this when the user asked for setup but did not specify which Bugfender capabilities they want enabled.
- Keep it to one compact question, not a long questionnaire.
- Prefer feature language the developer will recognize.

Typical options to confirm:

- basic remote logging only
- crash reporting
- user feedback / issue reporting
- Android logcat capture
- UI event logging
- symbol or mapping upload setup

If the user already gave strong clues, infer the feature set and skip the question.

### Step 3: Map the snippet to the real project

- Find the actual dependency file and initialization entrypoint in the repo.
- Identify where the Bugfender app key or token should live.
- Minimize the number of touched files.
- Preserve the project’s existing patterns and initialization style.

Examples:

- Android: dependency declaration, `Application` class, manifest if needed
- iOS: package/dependency setup, `AppDelegate`, SwiftUI app entrypoint if present
- Flutter: `pubspec.yaml`, `lib/main.dart`
- Unity: package manager + prefab + Inspector config
- .NET MAUI: `AppDelegate.cs`, `MainApplication.cs`
- Cordova: `config.xml`, plugin install command
- Ionic: `main.ts`, Capacitor sync
- Web: package manager file, app bootstrap entrypoint, env/config file
- React Native: entry file, Expo prebuild needs, native rebuild follow-up

### Step 4: Reduce developer decisions

When responding, do not dump every possible option. Choose the most likely correct path and explain only that path unless ambiguity is real.

- avoid large background explanations
- ask one short feature-selection question before enabling optional features that materially change the setup
- avoid offering many alternative integration styles by default

If the user asked for implementation, apply the changes directly instead of writing a long instruction list.

### Step 5: Verify with the smallest next step

End with one concrete verification step, for example:

- build or run the app
- emit a test log
- confirm the app appears in Bugfender
- confirm a test session or log line reaches the dashboard

Keep the close-out narrow: the developer should feel there is only one thing left to do.

## Decision rules

- Prefer implementation over explanation when the user is asking to set up the SDK in the current repo.
- Prefer the smallest valid integration over a feature-complete one.
- Prefer an explicit feature choice over silently enabling optional capabilities.
- Prefer existing project conventions over generic examples.
- If the repo structure is unclear, inspect more before asking.
- If the platform cannot be detected confidently, ask one short question instead of presenting multiple speculative setups.

## Output expectations

For explanation-only requests, return:

- detected platform
- exact files to change
- minimal code changes
- one verification step

For implementation requests, return:

- what was changed
- the key files touched
- one verification step

## Example requests

- Set up Bugfender in this app and keep it as hands-off as possible.
- Detect this project type and wire in the Bugfender SDK for me.
- Fetch the correct Bugfender snippet for this app and apply it to the repo.
- Add Bugfender to this mobile app and tell me only how to verify it worked.
