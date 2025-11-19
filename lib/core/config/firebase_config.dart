import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration and initialization
class FirebaseConfig {
  /// Initialize Firebase with platform-specific configuration
  ///
  /// This method should be called before runApp() in main.dart
  ///
  /// Returns true if initialization was successful, false otherwise
  static Future<bool> initialize() async {
    try {
      await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );

      if (kDebugMode) {
        print('✅ Firebase initialized successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase initialization failed: $e');
      }
      return false;
    }
  }

  /// Get platform-specific Firebase configuration options
  ///
  /// Note: You need to replace these placeholder values with your actual
  /// Firebase project configuration. Get these values from:
  /// - Android: google-services.json
  /// - iOS: GoogleService-Info.plist
  /// - Web: Firebase Console > Project Settings > Your apps
  static FirebaseOptions _getFirebaseOptions() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidOptions;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosOptions;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  // Android Firebase configuration
  // TODO: Replace these values with your actual Firebase project configuration
  // from google-services.json
  static const FirebaseOptions _androidOptions = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  // iOS Firebase configuration
  // TODO: Replace these values with your actual Firebase project configuration
  // from GoogleService-Info.plist
  static const FirebaseOptions _iosOptions = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );
}
