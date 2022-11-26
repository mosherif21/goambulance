import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../firebase_files/firebase_initializations.dart';
import '../features/onboarding/components/onboarding_shared_preferences.dart';

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
      if (AppInit.isWeb || AppInit.webMobile) {
        await activateWebAppCheck();
      } else if (AppInit.isAndroid) {
        await activateAndroidAppCheck();
      } else if (AppInit.isIos) {
        await activateIosAppCheck();
      }
      FlutterNativeSplash.remove();
      isInitialised = true;
    }
  }
}
