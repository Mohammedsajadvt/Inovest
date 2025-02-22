import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/foundation.dart' show kIsWeb;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDRRXT0HQKBgQC_x7dIDuFLb8Crb4zOXXr",
    appId: "1:113598315882921740455:android:YOUR_ANDROID_APP_ID",
    messagingSenderId: "113598315882921740455",
    projectId: "inovest-ea78c",
    storageBucket: "inovest-ea78c.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDRRXT0HQKBgQC_x7dIDuFLb8Crb4zOXXr",
    appId: "1:113598315882921740455:ios:YOUR_IOS_APP_ID",
    messagingSenderId: "113598315882921740455",
    projectId: "inovest-ea78c",
    storageBucket: "inovest-ea78c.appspot.com",
    iosBundleId: "com.example.inovest",
    iosClientId:
        "113598315882921740455-YOUR_IOS_CLIENT_ID.apps.googleusercontent.com",
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyC7JYWHl93JqaI6JtrO-RwVldhni5DpL_0",
      authDomain: "inovest-ea78c.firebaseapp.com",
      projectId: "inovest-ea78c",
      storageBucket: "inovest-ea78c.firebasestorage.app",
      messagingSenderId: "565236548413",
      appId: "1:565236548413:web:ebdf2040065655cf763b54",
      measurementId: "G-8SB707KX2Z");
}
