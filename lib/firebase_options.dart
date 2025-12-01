// This file will be auto-generated when you run: flutterfire configure
//
// Steps to configure Firebase:
// 1. Install FlutterFire CLI: dart pub global activate flutterfire_cli
// 2. Run: flutterfire configure
// 3. Select your Firebase project
// 4. This file will be automatically generated
//
// For now, this is a placeholder to prevent import errors.
// DO NOT commit this file to version control after configuration.

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3h_CEbSzkrbx_1DwTZiTPFCM3eTL39uw',
    appId: '1:879504683362:web:b0b6b5d6cbe019648e3c3b',
    messagingSenderId: '879504683362',
    projectId: 'e-commerce-f74bd',
    authDomain: 'e-commerce-f74bd.firebaseapp.com',
    storageBucket: 'e-commerce-f74bd.firebasestorage.app',
    measurementId: 'G-F0HPHN4LC7',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXymoxwtqHOODhcVZdmbOBTtJzjulCEkY',
    appId: '1:879504683362:ios:98ef5f9851987a0d8e3c3b',
    messagingSenderId: '879504683362',
    projectId: 'e-commerce-f74bd',
    storageBucket: 'e-commerce-f74bd.firebasestorage.app',
    iosBundleId: 'com.example.eCommerce',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbiFY40ZfxNtZ3O_520ejhGysml6YZ860',
    appId: '1:879504683362:android:07c45684c2584cf98e3c3b',
    messagingSenderId: '879504683362',
    projectId: 'e-commerce-f74bd',
    storageBucket: 'e-commerce-f74bd.firebasestorage.app',
  );

}
