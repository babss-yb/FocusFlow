import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyDYNOCOlTbDMk2OpO0s_aBEykoyn8NJDfU',
    appId: '1:595222311117:web:8ba538ce2195b44e08b984',
    messagingSenderId: '595222311117',
    projectId: 'finflow-app-25ef6',
    authDomain: 'finflow-app-25ef6.firebaseapp.com',
    storageBucket: 'finflow-app-25ef6.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYNOCOlTbDMk2OpO0s_aBEykoyn8NJDfU',
    appId: '1:595222311117:android:dummy_app_id',
    messagingSenderId: '595222311117',
    projectId: 'finflow-app-25ef6',
    storageBucket: 'finflow-app-25ef6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYNOCOlTbDMk2OpO0s_aBEykoyn8NJDfU',
    appId: '1:595222311117:ios:dummy_app_id',
    messagingSenderId: '595222311117',
    projectId: 'finflow-app-25ef6',
    storageBucket: 'finflow-app-25ef6.firebasestorage.app',
    iosBundleId: 'com.example.fintechApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDYNOCOlTbDMk2OpO0s_aBEykoyn8NJDfU',
    appId: '1:595222311117:ios:dummy_app_id',
    messagingSenderId: '595222311117',
    projectId: 'finflow-app-25ef6',
    storageBucket: 'finflow-app-25ef6.firebasestorage.app',
    iosBundleId: 'com.example.fintechApp.RunnerTests',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDYNOCOlTbDMk2OpO0s_aBEykoyn8NJDfU',
    appId: '1:595222311117:web:8ba538ce2195b44e08b984',
    messagingSenderId: '595222311117',
    projectId: 'finflow-app-25ef6',
    authDomain: 'finflow-app-25ef6.firebaseapp.com',
    storageBucket: 'finflow-app-25ef6.firebasestorage.app',
  );
}
