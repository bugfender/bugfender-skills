# iOS

Use this reference after detecting an iOS project.

## Detect

Check:

- `Podfile`, `Package.swift`, or `Cartfile`
- existing `BugfenderSDK` references
- UIKit `AppDelegate` vs SwiftUI `@main` app entry

Prefer the package manager already used by the repo.

## Minimum setup

Preferred install paths:

- Swift Package Manager: `https://github.com/bugfender/BugfenderSDK-iOS`
- CocoaPods: `pod 'BugfenderSDK', '~> 1.10'`
- Carthage only if the repo already uses Carthage

Initialize in `application(_:didFinishLaunchingWithOptions:)`:

```swift
Bugfender.setBaseURL(URL(string: "{BASE_URL}")!)
Bugfender.setApiURL(URL(string: "{SDK_API_URL}")!)
Bugfender.activateLogger("{APP_KEY}")
Bugfender.enableCrashReporting()
Bugfender.enableNSLogLogging()
Bugfender.enableUIEventLogging()
```

If the setup context includes a custom dashboard base URL or SDK API URL, apply them before `activateLogger(...)`.
For on-prem or non-default environments, treat `setBaseURL(...)` and `setApiURL(...)` as first-class integration hooks, not optional commentary.

If the app is SwiftUI-only, add an `AppDelegate` via `@UIApplicationDelegateAdaptor`.

## Integration points

- package manager file: `Podfile`, Xcode package dependency, or `Cartfile`
- UIKit bootstrap: `AppDelegate.swift`
- SwiftUI bootstrap: `YourApp.swift` plus new or existing `AppDelegate`
- symbol upload: Xcode Build Phases Run Script

## Hands-off defaults

- prefer Swift Package Manager if the repo is already on modern Xcode and no other package manager is enforced
- prefer AppDelegate initialization even in SwiftUI apps via adaptor pattern
- keep optional logging helpers off until the requested feature set is clear
- when custom `BASE_URL` or `SDK_API_URL` values are provided, wire them into `Bugfender.setBaseURL(...)` and `Bugfender.setApiURL(...)` before activation

## Symbolication

If symbol upload is part of the setup request, add the appropriate Run Script phase using the provided upload token:

- CocoaPods: `${PODS_ROOT}/BugfenderSDK/upload-symbols.sh {UPLOAD_SYMBOLS_TOKEN}`
- SPM: `${BUILD_DIR%Build/*}SourcePackages/checkouts/BugfenderSDK-iOS/xcode-upload-symbols/upload-symbols.sh {UPLOAD_SYMBOLS_TOKEN}`

## Verification

After activation, send one test signal:

```swift
bfprint("Bugfender initialized")
Bugfender.sendIssue(title: "Integration test", text: "Verifying Bugfender SDK")
```

## Common pitfalls

- SwiftUI app with no AppDelegate integration point
- changing Pods but reopening `.xcodeproj` instead of `.xcworkspace`
- symbol upload script on the wrong path
- missing system frameworks for some SPM setups
