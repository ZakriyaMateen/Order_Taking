// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDvG1JAxyF00KmfCK68FOnYN9ltrnNYCIg',
    appId: '1:762067809630:web:3b63f44fb86865e9128bcf',
    messagingSenderId: '762067809630',
    projectId: 'apporders-d2309',
    authDomain: 'apporders-d2309.firebaseapp.com',
    storageBucket: 'apporders-d2309.appspot.com',
    measurementId: 'G-T6LX795SZK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnmEcGnF4F3GevjtOKYGHKQtIzgnSSa-g',
    appId: '1:762067809630:android:624fd8c813abf3a4128bcf',
    messagingSenderId: '762067809630',
    projectId: 'apporders-d2309',
    storageBucket: 'apporders-d2309.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQYhifXKfkqFc4Ua5WUyeJhdK04JHrCZw',
    appId: '1:762067809630:ios:06ca64eba0b8554d128bcf',
    messagingSenderId: '762067809630',
    projectId: 'apporders-d2309',
    storageBucket: 'apporders-d2309.appspot.com',
    iosClientId: '762067809630-1ul2jhfuntkre0nrgjp4eticuoqqvf7i.apps.googleusercontent.com',
    iosBundleId: 'com.example.app2',
  );
}
