# MindLog - Build & Deployment Guide

Author: **Johnson Pillai** (Roll No: 150096724110)  
Course: **B.Tech CSE & AI - Cross Platform App Development Major Project**  
App Version: **1.0.0+1** | Package Name: `com.johnson.mindlog`

---

## 1. Prerequisites & Environment Setup

Ensure you have the following installed on your machine:
- **Flutter SDK**: 3.13.0 or higher (`flutter --version`)
- **Dart SDK**: 3.0.0 or higher (included with Flutter)
- **Java Development Kit (JDK)**: JDK 17 or higher
- **Android Studio / Xcode**: For Android/iOS platform builds
- **Google Chrome / Edge**: For web testing

Verify your environment configuration:
```bash
flutter doctor
```

---

## 2. Dependencies & Static Analysis

Before running or building the app, fetch dependencies and verify zero lint errors:

```bash
# 1. Fetch package dependencies
flutter pub get

# 2. Run static code analysis (must have 0 errors/warnings)
flutter analyze

# 3. Execute unit and widget tests
flutter test
```

---

## 3. Running the App in Development Mode

Run the app across different target platforms:

```bash
# Run on Google Chrome (Web)
flutter run -d chrome

# Run on macOS Desktop
flutter run -d macos

# Run on connected Android Emulator or Physical Device
flutter run -d android

# Run on iOS Simulator (macOS only)
flutter run -d iphone
```

---

## 4. Release Build Commands

### A. Android APK Build (Standalone Installer)
Generates an APK suitable for manual installation and testing:
```bash
flutter build apk --release
```
*Output artifact*: `build/app/outputs/flutter-apk/app-release.apk`

### B. Android App Bundle (Google Play Store)
Generates an optimized App Bundle (.aab) required by Google Play Console:
```bash
flutter build appbundle --release
```
*Output artifact*: `build/app/outputs/bundle/release/app-release.aab`

### C. Web Release Build
Compiles optimized static HTML/JS assets for web hosting (Netlify, Vercel, Firebase Hosting, GitHub Pages):
```bash
flutter build web --release
```
*Output artifact*: `build/web/`

### D. iOS Release Build (macOS only)
Generates an iOS app bundle or Xcode archive:
```bash
flutter build ios --release
```

---

## 5. Android Keystore & App Signing Setup

To upload release APKs or App Bundles to Google Play, the app must be signed with a production keystore.

### Step 1: Generate a Keystore File
Run `keytool` in terminal to create a private signing key:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### Step 2: Create `android/key.properties`
Create a file named `key.properties` inside the `android/` folder (ensure it is added to `.gitignore`):
```properties
storePassword=<YOUR_STORE_PASSWORD>
keyPassword=<YOUR_KEY_PASSWORD>
keyAlias=upload
storeFile=/Users/johnson/upload-keystore.jks
```

### Step 3: Reference `key.properties` in `android/app/build.gradle.kts`
The Gradle build script automatically checks for `key.properties` and applies the release signing configuration during `flutter build appbundle`.

---

## 6. Store Deployment Steps

### Google Play Store Deployment
1. Log into [Google Play Console](https://play.google.com/console).
2. Create a new application named **MindLog**.
3. Complete App Content requirements (Privacy Policy, Data Safety declaration: on-device storage only).
4. Go to **Production / Internal Testing** -> Create a new release.
5. Upload the signed `app-release.aab` file.
6. Submit for Google Play Store review.

### Apple App Store Deployment
1. Register App ID `com.johnson.mindlog` in Apple Developer Portal.
2. Open `ios/Runner.xcworkspace` in Xcode.
3. Select **Product -> Archive**.
4. Use **Organizer** to validate and upload the build to App Store Connect / TestFlight.

---

## 7. Understanding Flutter Build Modes

| Build Mode | Description & Use Case | Optimizations | Debug Features |
| :--- | :--- | :--- | :--- |
| **Debug** | Used during development. Enables hot reload, assertions, and full stack trace debugging. | Unoptimized, larger binary. | Hot Reload enabled, Observatory inspector active. |
| **Profile** | Used to analyze memory leaks, frame drops, and CPU usage. | Optimized like release, but keeps performance profiling hooks. | Timeline/DevTools profiling enabled. |
| **Release** | Target mode for end users and App Stores. | Fully obfuscated, AOT compiled to native machine code, tree-shaken assets. | Minimal binary size, maximum performance. |
