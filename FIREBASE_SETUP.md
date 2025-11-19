# Firebase Configuration Setup Guide

This guide will help you set up Firebase Authentication for the InCommonWith Flutter application.

## Prerequisites

- A Google account
- Flutter development environment set up
- Android Studio and/or Xcode installed (depending on target platforms)

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project" or "Create a project"
3. Enter project name: **incommonwith** (or your preferred name)
4. (Optional) Enable Google Analytics if desired
5. Click "Create project" and wait for setup to complete

## Step 2: Enable Authentication Methods

1. In your Firebase project, navigate to **Build → Authentication**
2. Click "Get started" if this is your first time
3. Go to the "Sign-in method" tab
4. Enable the authentication methods you want to use:
   - **Email/Password** (recommended for basic auth)
   - **Google** (recommended for social login)
   - Add other providers as needed (Facebook, Apple, etc.)

## Step 3: Configure Android App

### 3.1. Add Android App to Firebase

1. In Firebase Console, click the **Android icon** to add an Android app
2. Enter the following details:
   - **Android package name**: `com.yourcompany.incommonwith_flutter`
     - To find your actual package name, check `android/app/src/main/AndroidManifest.xml`
   - **App nickname** (optional): InCommonWith Android
   - **Debug signing certificate SHA-1** (optional but recommended):
     ```bash
     # Get your debug keystore SHA-1
     keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
     # Default password: android
     ```
3. Click "Register app"

### 3.2. Download and Install google-services.json

1. Download the `google-services.json` file
2. Copy it to: `android/app/google-services.json`
   - **Important**: Replace the `.example` file, don't rename it
3. Verify the file is in the correct location:
   ```
   android/
   └── app/
       ├── google-services.json          ✅ Correct location
       └── google-services.json.example  📝 Template (keep for reference)
   ```

### 3.3. Add Google Services Plugin

1. Open `android/build.gradle` (project-level)
2. Add the Google Services classpath:
   ```gradle
   buildscript {
       dependencies {
           // Add this line
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

3. Open `android/app/build.gradle` (app-level)
4. Add the plugin at the bottom of the file:
   ```gradle
   // At the very bottom of the file
   apply plugin: 'com.google.gms.google-services'
   ```

## Step 4: Configure iOS App

### 4.1. Add iOS App to Firebase

1. In Firebase Console, click the **iOS icon** to add an iOS app
2. Enter the following details:
   - **iOS bundle ID**: `com.yourcompany.incommonwith-flutter`
     - To find your actual bundle ID, open Xcode:
       1. Open `ios/Runner.xcworkspace`
       2. Select Runner in project navigator
       3. Check "Bundle Identifier" in General tab
   - **App nickname** (optional): InCommonWith iOS
3. Click "Register app"

### 4.2. Download and Install GoogleService-Info.plist

1. Download the `GoogleService-Info.plist` file
2. Copy it to: `ios/Runner/GoogleService-Info.plist`
   - **Important**: Replace the `.example` file
3. **Add to Xcode project**:
   1. Open `ios/Runner.xcworkspace` in Xcode
   2. Right-click on "Runner" folder in Project Navigator
   3. Select "Add Files to Runner..."
   4. Select the `GoogleService-Info.plist` file
   5. **Check** "Copy items if needed"
   6. Click "Add"

### 4.3. Update Info.plist URL Scheme

1. Open the `GoogleService-Info.plist` file you just downloaded
2. Find the value for `REVERSED_CLIENT_ID` (looks like `com.googleusercontent.apps.XXXXXXXXX`)
3. Open `ios/Runner/Info.plist`
4. Find the `CFBundleURLSchemes` section
5. Replace `com.googleusercontent.apps.YOUR-CLIENT-ID` with your actual `REVERSED_CLIENT_ID`

## Step 5: Update Firebase Configuration Code

### 5.1. Update firebase_config.dart

1. Open `lib/core/config/firebase_config.dart`
2. Find the `_androidOptions` section
3. Replace placeholder values with actual values from `android/app/google-services.json`:
   ```dart
   static const FirebaseOptions _androidOptions = FirebaseOptions(
     apiKey: 'YOUR_API_KEY',              // From "current_key" in api_key section
     appId: 'YOUR_APP_ID',                // From "mobilesdk_app_id"
     messagingSenderId: 'YOUR_SENDER_ID', // From project_info.project_number
     projectId: 'YOUR_PROJECT_ID',        // From project_info.project_id
     storageBucket: 'YOUR_BUCKET',        // From project_info.storage_bucket
   );
   ```

4. Find the `_iosOptions` section
5. Replace placeholder values with actual values from `ios/Runner/GoogleService-Info.plist`:
   ```dart
   static const FirebaseOptions _iosOptions = FirebaseOptions(
     apiKey: 'YOUR_API_KEY',              // From API_KEY
     appId: 'YOUR_APP_ID',                // From GOOGLE_APP_ID
     messagingSenderId: 'YOUR_SENDER_ID', // From GCM_SENDER_ID
     projectId: 'YOUR_PROJECT_ID',        // From PROJECT_ID
     storageBucket: 'YOUR_BUCKET',        // From STORAGE_BUCKET
     iosBundleId: 'YOUR_BUNDLE_ID',       // From BUNDLE_ID
   );
   ```

## Step 6: Initialize Firebase in Your App

Update your `lib/main.dart` to initialize Firebase:

```dart
import 'package:flutter/material.dart';
import 'package:incommonwith_flutter/core/config/firebase_config.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InCommonWith',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'InCommonWith'),
    );
  }
}
```

## Step 7: Verify Installation

### Android Verification

```bash
# Clean and rebuild
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..

# Run the app
flutter run
```

### iOS Verification

```bash
# Clean and rebuild
flutter clean
flutter pub get
cd ios
pod install
cd ..

# Run the app
flutter run
```

Check the console for "✅ Firebase initialized successfully" message.

## Troubleshooting

### Android Issues

**Error: google-services.json not found**
- Ensure `google-services.json` is in `android/app/` directory
- Verify the file name is exactly `google-services.json` (not `.example`)

**Error: Plugin with id 'com.google.gms.google-services' not found**
- Check that you added the classpath in project-level `build.gradle`
- Ensure you applied the plugin in app-level `build.gradle`

**Build errors after adding Firebase**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS Issues

**Error: GoogleService-Info.plist not found**
- Ensure the file is added to Xcode project (not just copied to folder)
- Verify it's in the `ios/Runner/` directory
- Check it appears in Xcode Project Navigator

**URL Scheme errors**
- Verify `REVERSED_CLIENT_ID` matches the value in `GoogleService-Info.plist`
- Check `CFBundleURLSchemes` in `Info.plist` is correctly configured

**Pod installation issues**
```bash
cd ios
pod deintegrate
pod install
cd ..
```

## Security Notes

1. **Never commit these files to version control**:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

2. These files are already in `.gitignore`, but verify:
   ```bash
   git status
   # Should NOT show google-services.json or GoogleService-Info.plist
   ```

3. For team collaboration:
   - Share these files securely (encrypted, password manager, secure file sharing)
   - Each developer needs their own copy
   - Use different Firebase projects for dev/staging/production

## Next Steps

After Firebase is configured:

1. Implement authentication screens (login, register, password reset)
2. Create authentication service using `firebase_auth` package
3. Set up authentication state management
4. Implement protected routes
5. Add user profile management

## Useful Resources

- [Firebase Console](https://console.firebase.google.com)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Firebase Android Setup](https://firebase.google.com/docs/android/setup)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
