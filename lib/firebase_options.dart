import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for windows');
      case TargetPlatform.linux:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for linux');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment(
      'FIREBASE_WEB_API_KEY',
      defaultValue: '',
    ),
    appId: String.fromEnvironment(
      'FIREBASE_WEB_APP_ID',
      defaultValue: '',
    ),
    messagingSenderId: String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
      defaultValue: '',
    ),
    projectId: String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: '',
    ),
    authDomain: String.fromEnvironment(
      'FIREBASE_AUTH_DOMAIN',
      defaultValue: '',
    ),
    storageBucket: String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: '',
    ),
    measurementId: String.fromEnvironment(
      'FIREBASE_MEASUREMENT_ID',
      defaultValue: '',
    ),
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLpzIdiy33vjYw5JufYLq2__nHPssGtrQ',
    appId: '1:83803930192:android:c7708a66ec3a1e3d94db55',
    messagingSenderId: '83803930192',
    projectId: 'incommonwith-flutter',
    storageBucket: 'incommonwith-flutter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMu9K9t8tr4_Z9J19zoMCh4lgxBTxJpS4',
    appId: '1:83803930192:ios:9f8cfc22d9d7791c94db55',
    messagingSenderId: '83803930192',
    projectId: 'incommonwith-flutter',
    storageBucket: 'incommonwith-flutter.firebasestorage.app',
    iosBundleId: 'com.coomar.flutterIIM',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.incommonwithFlutter',
  );
}