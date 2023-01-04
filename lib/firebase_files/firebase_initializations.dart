import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> initializeFireBaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> activateWebAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LeqGb8iAAAAAJKFulsS32nYgwxFYlQ9yqMPMrld',
  );
}

Future<void> activateAndroidAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    // ignore: deprecated_member_use
    androidProvider: AndroidProvider.safetyNet,
  );
}

Future<void> activateIosAppCheck() async {}
