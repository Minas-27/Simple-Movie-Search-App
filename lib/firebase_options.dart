import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
    apiKey: 'AIzaSyChAhxK98sVPSDWlJAwHPD-NDFm5JLVMwo',
    appId: '1:408595630423:web:e28a5a364be20f4bd39612',
    messagingSenderId: '408595630423',
    projectId: 'simple-authentication-16057',
    authDomain: 'simple-authentication-16057.firebaseapp.com',
    storageBucket: 'simple-authentication-16057.firebasestorage.app',
    measurementId: 'G-ESD6D40RNM',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCa0Zqs2LQgv-pGnz9AmERiMPewmNPI4rI',
    appId: '1:408595630423:ios:be8491afbbefd74cd39612',
    messagingSenderId: '408595630423',
    projectId: 'simple-authentication-16057',
    storageBucket: 'simple-authentication-16057.firebasestorage.app',
    iosBundleId: 'com.example.simpleAuthentication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChAhxK98sVPSDWlJAwHPD-NDFm5JLVMwo',
    appId: '1:408595630423:web:9f70ef53fbe92c0dd39612',
    messagingSenderId: '408595630423',
    projectId: 'simple-authentication-16057',
    authDomain: 'simple-authentication-16057.firebaseapp.com',
    storageBucket: 'simple-authentication-16057.firebasestorage.app',
    measurementId: 'G-F24JWWL33R',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCa0Zqs2LQgv-pGnz9AmERiMPewmNPI4rI',
    appId: '1:408595630423:ios:be8491afbbefd74cd39612',
    messagingSenderId: '408595630423',
    projectId: 'simple-authentication-16057',
    storageBucket: 'simple-authentication-16057.firebasestorage.app',
    iosBundleId: 'com.example.simpleAuthentication',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaO8LiZ6ctWf2ZkjWbAdMjQ4tmKYGZEnU',
    appId: '1:408595630423:android:aae8d6cf0232e448d39612',
    messagingSenderId: '408595630423',
    projectId: 'simple-authentication-16057',
    storageBucket: 'simple-authentication-16057.firebasestorage.app',
  );
}
