// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGzAmgiaL3jo7GvU_TjHpxiLOxUnBGUow',
    appId: '1:924559689012:android:3abd9d63c9d9cbe6de9161',
    messagingSenderId: '924559689012',
    projectId: 'ristouguide-8aa1d',
    databaseURL: 'https://ristouguide-8aa1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ristouguide-8aa1d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNIAcYBKdLKV-AaKi2VS0LAASRANVJUhc',
    appId: '1:924559689012:ios:cca8e25911de93eede9161',
    messagingSenderId: '924559689012',
    projectId: 'ristouguide-8aa1d',
    databaseURL: 'https://ristouguide-8aa1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ristouguide-8aa1d.appspot.com',
    iosBundleId: 'com.example.myapp',
  );
}
