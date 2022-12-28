import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/authentication_repository.dart';
import '../../firebase_files/firebase_initializations.dart';
import '../../localization/language/language_functions.dart';
import '../features/onboarding/components/onboarding_shared_preferences.dart';
import '../routing/splash_screen.dart';

enum Language { english, arabic }

enum InputType { email, phone, text }

class AppInit {
  static bool showOnBoard = false;
  static bool notWebMobile = false;
  static bool isWeb = false;
  static bool isAndroid = false;
  static bool isIos = false;
  static bool webMobile = false;
  static bool isInitialised = false;
  static bool isConstantsInitialised = false;
  static late SharedPreferences prefs;
  static bool isLocaleSet = false;
  static late final Locale setLocale;
  static Language currentDeviceLanguage = Language.english;
  static Transition transition = Transition.leftToRightWithFade;
  // ignore: prefer_typing_uninitialized_variables
  static late final notificationToken;
  static Future<void> initializeConstants() async {
    if (!isConstantsInitialised) {
      prefs = await SharedPreferences.getInstance();
      isLocaleSet = await getIfLocaleIsSet();
      showOnBoard = await getShowOnBoarding();
      if (isLocaleSet) {
        setLocale = await getLocale();
      } else {
        setLocale = Get.deviceLocale ?? const Locale('en', 'US');
      }
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
      isConstantsInitialised = true;
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
      if (!isWeb) {
        notificationToken = await FirebaseMessaging.instance.getToken();
      }
      Get.put(AuthenticationRepository());
      isInitialised = true;
      removeSplashScreen();
    }
  }

  static Transition getPageTransition() {
    return AppInit.currentDeviceLanguage == Language.english
        ? Transition.rightToLeftWithFade
        : Transition.leftToRightWithFade;
  }
}
