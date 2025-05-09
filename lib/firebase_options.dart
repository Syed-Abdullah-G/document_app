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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3fzEGeBF09hCQBF4AUqS1h_v7rT4OHHw',
    appId: '1:280792716020:android:dc64cff0a7b48dad4ac4a1',
    messagingSenderId: '280792716020',
    projectId: 'todo-app-c91f7',
    storageBucket: 'todo-app-c91f7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBp19-PHh69t4EhQ_t6vF5FNeP23grFAfE',
    appId: '1:280792716020:ios:bb293b44003489bd4ac4a1',
    messagingSenderId: '280792716020',
    projectId: 'todo-app-c91f7',
    storageBucket: 'todo-app-c91f7.appspot.com',
    androidClientId: '280792716020-3e9i7jss4utp65g01hnffv55pmeh1hmo.apps.googleusercontent.com',
    iosClientId: '280792716020-d8492cdch4pli0gfpumifln5ut9rsmgf.apps.googleusercontent.com',
    iosBundleId: 'com.example.todo',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyADJrC2P7LtPW5Q6AZb50Zt_v3lIK7k6C4',
    appId: '1:280792716020:web:17b49ff15852e3504ac4a1',
    messagingSenderId: '280792716020',
    projectId: 'todo-app-c91f7',
    authDomain: 'todo-app-c91f7.firebaseapp.com',
    storageBucket: 'todo-app-c91f7.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBp19-PHh69t4EhQ_t6vF5FNeP23grFAfE',
    appId: '1:280792716020:ios:bb293b44003489bd4ac4a1',
    messagingSenderId: '280792716020',
    projectId: 'todo-app-c91f7',
    storageBucket: 'todo-app-c91f7.appspot.com',
    androidClientId: '280792716020-3e9i7jss4utp65g01hnffv55pmeh1hmo.apps.googleusercontent.com',
    iosClientId: '280792716020-d8492cdch4pli0gfpumifln5ut9rsmgf.apps.googleusercontent.com',
    iosBundleId: 'com.example.todo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyADJrC2P7LtPW5Q6AZb50Zt_v3lIK7k6C4',
    appId: '1:280792716020:web:4bb2cb0ec63365a74ac4a1',
    messagingSenderId: '280792716020',
    projectId: 'todo-app-c91f7',
    authDomain: 'todo-app-c91f7.firebaseapp.com',
    storageBucket: 'todo-app-c91f7.appspot.com',
  );

}