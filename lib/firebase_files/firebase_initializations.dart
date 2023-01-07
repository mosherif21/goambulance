import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';

Future<void> initializeFireBaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> activateWebAppCheck() async {
  await FirebaseAppCheck.instance
      .activate(
    webRecaptchaSiteKey: '6LeqGb8iAAAAAJKFulsS32nYgwxFYlQ9yqMPMrld',
  )
      .onError((error, stackTrace) {
    if (kDebugMode) print(error);
  });
}

Future<void> activateAndroidAppCheck() async {
  await FirebaseAppCheck.instance
      .activate(
    // ignore: deprecated_member_use
    androidProvider: AndroidProvider.safetyNet,
  )
      .onError((error, stackTrace) {
    if (kDebugMode) print(error);
  });
}

Future<void> activateIosAppCheck() async {}
