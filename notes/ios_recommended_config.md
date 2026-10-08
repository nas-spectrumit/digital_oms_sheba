# Complete Recommended iOS Configuration & Crash Prevention Guide for Flutter

> **A comprehensive reference and direct AI prompt guide for configuring modern Flutter iOS/iPadOS projects for App Store readiness, automated versioning, iPadOS Stage Manager compatibility, crash prevention, and smooth reviews.**

---

## 🎯 Direct AI Prompt (Copy & Paste for Other Projects)

```markdown
Please configure and audit the iOS setup for this Flutter project following Apple App Store best practices:

1. Version & Build Number Syncing:
   - Ensure Xcode Identity is set to read from `pubspec.yaml` using:
     - Version: `$(FLUTTER_BUILD_NAME)`
     - Build: `$(FLUTTER_BUILD_NUMBER)`
   - Never hardcode version strings directly in Xcode.

2. Fix/Prevent iPadOS & iOS 27+ Crash (`UIScene` Lifecycle & `MissingPluginException` Prevention):
   - Add `UIApplicationSceneManifest` (with `flutter` scene configuration) and `UISupportedInterfaceOrientations~ipad` to `ios/Runner/Info.plist`.
   - Add `<key>UIRequiresFullScreen</key><true/>` to `ios/Runner/Info.plist`.
   - Create `ios/Runner/SceneDelegate.swift` inheriting from `FlutterSceneDelegate` (NEVER a plain `UIWindowSceneDelegate` which breaks plugin method channels).
   - Update `ios/Runner/AppDelegate.swift` to conform to `FlutterImplicitEngineDelegate` and register plugins inside `didInitializeImplicitFlutterEngine(_:)`.
   - Register `SceneDelegate.swift` in `ios/Runner.xcodeproj/project.pbxproj` (PBXBuildFile, PBXFileReference, PBXGroup Runner, and PBXSourcesBuildPhase).

3. Essential `Info.plist` Flags:
   - Add `ITSAppUsesNonExemptEncryption = false` (bypasses App Store export compliance prompts).
   - Add `CADisableMinimumFrameDurationOnPhone = true` (enables 120Hz ProMotion on iPhone Pro models).
   - Add `UIApplicationSupportsIndirectInputEvents = true` (iPad trackpad/mouse input support).
   - Configure `LSApplicationQueriesSchemes` with `tel`, `https`, `http` for `url_launcher`.

4. Privacy Manifest:
   - Ensure `ios/Runner/PrivacyInfo.xcprivacy` exists and is registered in the Xcode Runner target resources.

5. Podfile Deployment Target:
   - Set `platform :ios, '15.0'` (or higher) to prevent CocoaPods version mismatches with modern plugins.

6. App Icons & Alpha Transparency:
   - Configure `flutter_launcher_icons` in `pubspec.yaml` with `remove_alpha_ios: true` (Apple strictly rejects icons with alpha channels: ITMS-90717).
   - Generate icons using `dart run flutter_launcher_icons`.

Please inspect `ios/Runner/Info.plist`, `ios/Runner/SceneDelegate.swift`, `ios/Runner/AppDelegate.swift`, `ios/Podfile`, `pubspec.yaml`, and `ios/Runner.xcodeproj/project.pbxproj` and apply any missing configurations.
```

---

## 📌 1. Versioning: Single Source of Truth (`pubspec.yaml`)

Never type version numbers directly inside Xcode. Keep `pubspec.yaml` as the single source of truth.

### How it works:
In `pubspec.yaml`:
```yaml
version: 1.0.92+83
#         ▲      ▲
#      Version  Build Number
```
* **Version Name (`1.0.92`):** Mapped to `$(FLUTTER_BUILD_NAME)`.
* **Build Number (`83`):** Mapped to `$(FLUTTER_BUILD_NUMBER)`.

### Xcode Identity Setting:
Go to **Xcode > TARGETS > Runner > General > Identity**:
* **Version:** Must be `$(FLUTTER_BUILD_NAME)` *(or the resolved version)*
* **Build:** Must be `$(FLUTTER_BUILD_NUMBER)` *(or the resolved build number)*

> **⚠️ Important:** When you change the version in `pubspec.yaml`, run:
> ```bash
> flutter pub get
> ```
> Flutter automatically generates `ios/Flutter/Generated.xcconfig` with the new values, and Xcode immediately reflects them.

---

## 📌 2. Fix iPadOS & iOS 27+ Crash: `UIScene` Lifecycle Adoption & `MissingPluginException` Prevention

### Why This Happens:
1. **Apple Mandate (iOS 27+ & Xcode 27+):** Apple strictly requires the `UIScene` lifecycle for all UIKit apps built with the iOS 27+ SDK ([Apple Documentation](https://developer.apple.com/documentation/uikit/transitioning-to-the-uikit-scene-based-life-cycle)). Apps lacking `UIApplicationSceneManifest` fail to launch on startup.
2. **iPadOS Multitasking:** On iPadOS, running without scenes or without `UIRequiresFullScreen` triggers `___UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption` and terminates the app.

---

### ⚠️ CRITICAL GOTCHA: The `MissingPluginException` Trap

> **DO NOT** create a generic `UIResponder, UIWindowSceneDelegate` that manually instantiates `FlutterViewController` from `Main.storyboard`!

#### The Flawed Approach (What causes all plugins to break):
```swift
// ❌ WRONG: Breaks ALL Flutter plugins with MissingPluginException!
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: windowScene)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    if let flutterViewController = appDelegate?.window?.rootViewController as? FlutterViewController {
      window.rootViewController = flutterViewController
    } else {
      // ⚠️ BUG: appDelegate?.window is ALWAYS nil under UIScene!
      // This instantiates a BRAND NEW FlutterViewController with a separate, detached engine!
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      window.rootViewController = storyboard.instantiateInitialViewController()
    }
    self.window = window
    window.makeKeyAndVisible()
  }
}
```

#### Why This Breaks Plugins:
1. Under `UISceneDelegate`, UIKit delegates window management entirely to the scene — `appDelegate.window` is **always `nil`**.
2. The `if` branch fails, and the `else` branch instantiates a new `FlutterViewController` from the storyboard.
3. This creates a **new, unlinked `FlutterEngine`**.
4. In `AppDelegate.swift`, `GeneratedPluginRegistrant.register(with: self)` was called in `didFinishLaunchingWithOptions:` on the old/nil engine. It **never runs on the new scene engine**.
5. **Result:** Every native method channel in the app (`flutter_secure_storage`, `package_info_plus`, `permission_handler`, `device_info_plus`, `geolocator`, `shared_preferences`, etc.) immediately fails with:
   ```
   MissingPluginException(No implementation found for method ... on channel ...)
   ```

---

### The Official Flutter Solution: `FlutterSceneDelegate` + `FlutterImplicitEngineDelegate`

Official Flutter documentation: [UIScene Adoption in Flutter](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate).

#### Step 2.1: `ios/Runner/Info.plist` Entries
Add the following inside `<dict>`:

```xml
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<false/>
		<key>UISceneConfigurations</key>
		<dict>
			<key>UIWindowSceneSessionRoleApplication</key>
			<array>
				<dict>
					<key>UISceneClassName</key>
					<string>UIWindowScene</string>
					<key>UISceneConfigurationName</key>
					<string>flutter</string>
					<key>UISceneDelegateClassName</key>
					<string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
					<key>UISceneStoryboardFile</key>
					<string>Main</string>
				</dict>
			</array>
		</dict>
	</dict>
	<key>UIRequiresFullScreen</key>
	<true/>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
```

#### Step 2.2: Create `ios/Runner/SceneDelegate.swift`
Create `ios/Runner/SceneDelegate.swift` inheriting directly from **`FlutterSceneDelegate`**:

```swift
import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {}
```
> `FlutterSceneDelegate` is Flutter's built-in scene delegate. It automatically coordinates the window, root `FlutterViewController`, scene lifecycle, and the engine bridge without any boilerplate.

#### Step 2.3: Update `ios/Runner/AppDelegate.swift`
1. Conform `AppDelegate` to **`FlutterImplicitEngineDelegate`**.
2. Remove `GeneratedPluginRegistrant.register(with: self)` from `didFinishLaunchingWithOptions`.
3. Implement `didInitializeImplicitFlutterEngine(_:)` to register plugins directly with the scene's engine:

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Process-level configurations (e.g. Google Maps API key, notification delegates)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Register plugins when the implicit scene engine is initialized
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
```

#### Step 2.4: Register in Xcode (`project.pbxproj`)
Ensure `SceneDelegate.swift` is added to Xcode's `Runner` target:
- `PBXBuildFile`: `SceneDelegate.swift in Sources`
- `PBXFileReference`: `SceneDelegate.swift`
- `PBXGroup (Runner)`: `SceneDelegate.swift`
- `PBXSourcesBuildPhase`: `SceneDelegate.swift in Sources`

---

## 📌 3. Other Essential `ios/Runner/Info.plist` Keys

Add these key entries inside the root `<dict>` of `ios/Runner/Info.plist`:

### A. Bypass Export Compliance (`ITSAppUsesNonExemptEncryption`)
Avoids the manual "Does your app use encryption?" questionnaire on every App Store Connect upload:
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

### B. Enable 120Hz ProMotion Refresh Rate
Allows smooth 120Hz animations on iPhone Pro models instead of capping at 60Hz:
```xml
<key>CADisableMinimumFrameDurationOnPhone</key>
<true/>
```

### C. Indirect Input (Trackpad & Mouse for iPad)
Ensures proper pointer interaction when an iPad has a Magic Keyboard or trackpad connected:
```xml
<key>UIApplicationSupportsIndirectInputEvents</key>
<true/>
```

### D. URL Launcher Schemes (`LSApplicationQueriesSchemes`)
Allows opening external phone links, browsers, or maps without failing silently:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>tel</string>
	<string>https</string>
	<string>http</string>
</array>
```

---

## 📌 4. Privacy Manifest (`PrivacyInfo.xcprivacy`)

Apple strictly mandates `PrivacyInfo.xcprivacy` for all App Store submissions.

Place this file at `ios/Runner/PrivacyInfo.xcprivacy` and ensure it is included in Xcode's **Runner > Resources**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSPrivacyAccessedAPITypes</key>
	<array>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategoryUserDefaults</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>CA92.1</string>
			</array>
		</dict>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>C617.1</string>
			</array>
		</dict>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategoryDiskSpace</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>85F4.1</string>
			</array>
		</dict>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategorySystemBootTime</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>35F9.1</string>
			</array>
		</dict>
	</array>
	<key>NSPrivacyCollectedDataTypes</key>
	<array/>
	<key>NSPrivacyTracking</key>
	<false/>
	<key>NSPrivacyTrackingDomains</key>
	<array/>
</dict>
</plist>
```

---

## 📌 5. `ios/Podfile` Deployment Target

Modern Flutter plugins frequently require iOS 14.0 or 15.0 minimum. Prevent build errors by setting the minimum deployment target at the top of `ios/Podfile`:

```ruby
platform :ios, '15.0'
```

And in the `post_install` block:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
```

---

## 📌 6. App Icon Setup & Alpha Transparency Prevention (`flutter_launcher_icons`)

### Why This is Critical for iOS:
Apple's automated App Store validation strictly checks every app icon in the asset catalog. If any icon contains an **alpha channel (transparency)**, Apple automatically rejects the build upon upload with:
> `ITMS-90717: Invalid App Store Icon - The App Store Icon in the asset catalog in 'Runner.app' can't be transparent nor contain an alpha channel.`

### `pubspec.yaml` Configuration:
Add `flutter_launcher_icons` under `dev_dependencies` and configure the root block with **`remove_alpha_ios: true`**:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4

flutter_launcher_icons:
  android: true
  ios: true
  remove_alpha_ios: true # ⚠️ CRITICAL: Removes alpha/transparency to prevent ITMS-90717 rejection
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/images/app_icon.png"
  web:
    generate: true
    image_path: "assets/images/app_icon.png"
    background_color: "#ffffff"
    theme_color: "#ffffff"
  windows:
    generate: true
    image_path: "assets/images/app_icon.png"
    icon_size: 256
  macos:
    generate: true
    image_path: "assets/images/app_icon.png"
```

### Command to Generate Icons:
```bash
dart run flutter_launcher_icons
```

---

## 📌 7. Standard Build & Release Checklist

Whenever updating the app version:

1. **Bump version in `pubspec.yaml`**:
   ```yaml
   version: 1.0.0+2
   ```
2. **Generate icons (if icon changed)**:
   ```bash
   dart run flutter_launcher_icons
   ```
3. **Sync dependencies and CocoaPods**:
   ```bash
   flutter pub get
   cd ios && pod install && cd ..
   ```
4. **Archive via Xcode**:
   * Open: `open ios/Runner.xcworkspace`
   * Select: **Any iOS Device (arm64)**
   * Menu: **Product > Archive**
   * Click: **Distribute App** to upload to App Store Connect.

---

## ✉️ App Store Resolution Center Reply Template

If you were previously rejected by Apple Review under **Guideline 2.1(a)** for the iPad launch crash, reply with:

> **Subject:** Guideline 2.1(a) - Performance - App Completeness (Crash on Launch Resolved)
>
> Dear Apple Review Team,
>
> Thank you for bringing this issue to our attention.
>
> **Root Cause:**
> The crash (`___UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption`) was triggered on iPadOS because the application lacked the required `UIScene` lifecycle configuration (`UIApplicationSceneManifest` and `SceneDelegate`).
>
> **Resolution:**
> 1. Configured `UIApplicationSceneManifest` in `Info.plist` and implemented `SceneDelegate` conforming to `FlutterSceneDelegate`.
> 2. Updated `AppDelegate` conforming to `FlutterImplicitEngineDelegate` to register plugins when the implicit Flutter engine initializes.
> 3. Added complete iPad orientation specifications (`UISupportedInterfaceOrientations~ipad`) and `<key>UIRequiresFullScreen</key><true/>`.
> 4. Verified launch and operation on iPad/iPhone simulators and physical devices.
>
> We have uploaded a new build for your review. Please let us know if any further information is needed.
