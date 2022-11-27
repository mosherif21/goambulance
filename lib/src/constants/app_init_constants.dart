import 'package:flutter/foundation.dart';

import '../../firebase_files/firebase_initializations.dart';
import '../features/onboarding/components/onboarding_shared_preferences.dart';
import '../routing/splash_screen.dart';

class AppInit {
  static bool showOnBoard = false;
  static bool notWebMobile = false;
  static bool isWeb = false;
  static bool isAndroid = false;
  static bool isIos = false;
  static bool webMobile = false;
  static bool isInitialised = false;

  static Future<void> initializeConstants() async {
    showOnBoard = await getShowOnBoarding();
    isWeb = kIsWeb;
    notWebMobile = isWeb &&
        !(defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    webMobile = isWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);

    if (defaultTargetPlatform == TargetPlatform.android && !isWeb) {
      isAndroid = true;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS && !isWeb) {
      isIos = true;
    }
  }

  static Future<void> initialize() async {
    if (!isInitialised) {
      await initializeFireBaseApp();
      if (kDebugMode) print('firebase app initialized');
      if (AppInit.isWeb || AppInit.webMobile) {
        await activateWebAppCheck();
        if (kDebugMode) print('web app check initialized');
      } else if (AppInit.isAndroid) {
        await activateAndroidAppCheck();
        if (kDebugMode) print('android app check initialized');
      } else if (AppInit.isIos) {
        await activateIosAppCheck();
        if (kDebugMode) print('ios app check initialized');
      }
      if (kDebugMode) print('Firebase initialized');
      isInitialised = true;
      removeSplash();
    }
  }
}
