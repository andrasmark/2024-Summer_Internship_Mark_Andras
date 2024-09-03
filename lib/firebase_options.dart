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
        return windows;
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
    apiKey: 'AIzaSyChFKsWPivbrv_etCmrWvSqoroW3A8VccY',
    appId: '1:750225084208:web:d68025ca3681765f5602f5',
    messagingSenderId: '750225084208',
    projectId: 'eventcalendar-fa279',
    authDomain: 'eventcalendar-fa279.firebaseapp.com',
    storageBucket: 'eventcalendar-fa279.appspot.com',
    measurementId: 'G-5FWLX8J137',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxy-K9pdrRWt_-miIQUtymXWBFvGFOODE',
    appId: '1:750225084208:android:4caa62e2ccb89d3b5602f5',
    messagingSenderId: '750225084208',
    projectId: 'eventcalendar-fa279',
    storageBucket: 'eventcalendar-fa279.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMjDVCOgd_phgWdyGAGgcFyRxk0teT6Tg',
    appId: '1:750225084208:ios:42b283d4388f8b845602f5',
    messagingSenderId: '750225084208',
    projectId: 'eventcalendar-fa279',
    storageBucket: 'eventcalendar-fa279.appspot.com',
    iosBundleId: 'com.example.eventCalendar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMjDVCOgd_phgWdyGAGgcFyRxk0teT6Tg',
    appId: '1:750225084208:ios:42b283d4388f8b845602f5',
    messagingSenderId: '750225084208',
    projectId: 'eventcalendar-fa279',
    storageBucket: 'eventcalendar-fa279.appspot.com',
    iosBundleId: 'com.example.eventCalendar',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChFKsWPivbrv_etCmrWvSqoroW3A8VccY',
    appId: '1:750225084208:web:0d2746ed95a0f1b45602f5',
    messagingSenderId: '750225084208',
    projectId: 'eventcalendar-fa279',
    authDomain: 'eventcalendar-fa279.firebaseapp.com',
    storageBucket: 'eventcalendar-fa279.appspot.com',
    measurementId: 'G-G3Q662PB1F',
  );
}
