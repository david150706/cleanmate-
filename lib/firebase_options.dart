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
        return macos;
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
    apiKey: 'AIzaSyATd4QLFvN0dmt8oNcRUa9O8JQUic7rfV4',
    appId: '1:539488796281:web:e3803a8b3af0a867675ea8',
    messagingSenderId: '539488796281',
    projectId: 'cleanmate-df969',
    authDomain: 'cleanmate-df969.firebaseapp.com',
    storageBucket: 'cleanmate-df969.appspot.com',
    measurementId: 'G-SYX4NQZ4S6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3b23gOoaLD2-WRZUg4PnhNdWi3r57x5Y',
    appId: '1:539488796281:android:5703cde2147e202a675ea8',
    messagingSenderId: '539488796281',
    projectId: 'cleanmate-df969',
    storageBucket: 'cleanmate-df969.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBofupyPv8ecXXfJ0aiQjg-BxLs0HtFA_4',
    appId: '1:539488796281:ios:9561f981c7a82f00675ea8',
    messagingSenderId: '539488796281',
    projectId: 'cleanmate-df969',
    storageBucket: 'cleanmate-df969.appspot.com',
    androidClientId: '539488796281-4a6lpskneh2n1jm16ngkqtm7hprnnfk0.apps.googleusercontent.com',
    iosClientId: '539488796281-o2lr09eni31jv8lcqpjjdv8547ni5fta.apps.googleusercontent.com',
    iosBundleId: 'com.example.cleanmate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBofupyPv8ecXXfJ0aiQjg-BxLs0HtFA_4',
    appId: '1:539488796281:ios:9561f981c7a82f00675ea8',
    messagingSenderId: '539488796281',
    projectId: 'cleanmate-df969',
    storageBucket: 'cleanmate-df969.appspot.com',
    androidClientId: '539488796281-4a6lpskneh2n1jm16ngkqtm7hprnnfk0.apps.googleusercontent.com',
    iosClientId: '539488796281-o2lr09eni31jv8lcqpjjdv8547ni5fta.apps.googleusercontent.com',
    iosBundleId: 'com.example.cleanmate',
  );
}