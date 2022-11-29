import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/language/language_functions.dart';
import '../features/onboarding/components/onboarding_shared_preferences.dart';
import '../routing/splash_screen.dart';

enum Language { english, arabic }

class AppInit {
  static bool showOnBoard = false;
  static bool notWebMobile = false;
  static bool isWeb = false;
  static bool isAndroid = false;
  static bool isIos = false;
  static bool webMobile = false;
  static bool isInitialised = false;
  static late SharedPreferences prefs;
  static bool isLocaleSet = false;
  static late final Locale setLocale;
  static Language currentDeviceLanguage = Language.english;

  //screen sizes vars
  static late double pixelRatio;
  //Size in physical pixels
  static late Size physicalScreenSize;
  static late double physicalWidth;
  static late double physicalHeight;
//Size in logical pixels
  static late Size logicalScreenSize;
  static late double logicalWidth;
  static late double logicalHeight;
//Padding in physical pixels
  static late WindowPadding padding;
//Safe area paddings in logical pixels
  static late double paddingLeft;
  static late double paddingRight;
  static late double paddingTop;
  static late double paddingBottom;
//Safe area in logical pixels
  static late double safeWidth;
  static late double safeHeight;

  static Future<void> initializeConstants() async {
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

    pixelRatio = window.devicePixelRatio;

    //Size in physical pixels
    physicalScreenSize = window.physicalSize;
    physicalWidth = physicalScreenSize.width;
    physicalHeight = physicalScreenSize.height;

//Size in logical pixels
    logicalScreenSize = window.physicalSize / pixelRatio;
    logicalWidth = logicalScreenSize.width;
    logicalHeight = logicalScreenSize.height;

//Padding in physical pixels
    padding = window.padding;

//Safe area paddings in logical pixels
    paddingLeft = window.padding.left / window.devicePixelRatio;
    paddingRight = window.padding.right / window.devicePixelRatio;
    paddingTop = window.padding.top / window.devicePixelRatio;
    paddingBottom = window.padding.bottom / window.devicePixelRatio;

//Safe area in logical pixels
    safeWidth = logicalWidth - paddingLeft - paddingRight;
    safeHeight = logicalHeight - paddingTop - paddingBottom;
  }

  static Future<void> initialize() async {
    if (!isInitialised) {
      /*
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
      if (kDebugMode) print('Firebase initialized');*/
      isInitialised = true;
      removeSplashScreen();
    }
  }
}
