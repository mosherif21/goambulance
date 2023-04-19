import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/constants/app_init_constants.dart';
import '../../src/constants/enums.dart';
import '../../src/features/intro_screen/components/onboarding_shared_preferences.dart';
import '../../src/general/general_functions.dart';

const String languageCode = 'languageCode';

//languages code
const String english = 'en';
const String arabic = 'ar';

Future<void> setLocale(String aLanguageCode) async {
  await AppInit.prefs.setString(languageCode, aLanguageCode);
}

Future<bool> getIfLocaleIsSet() async {
  if (AppInit.prefs.getString(languageCode) != null) {
    return true;
  } else {
    return false;
  }
}

Locale getLocale() {
  String? aLanguageCode = AppInit.prefs.getString(languageCode);
  return _locale(aLanguageCode!);
}

Locale _locale(String aLanguageCode) {
  switch (aLanguageCode) {
    case english:
      AppInit.currentLanguage = Language.english;
      return const Locale(english, 'US');
    case arabic:
      AppInit.currentLanguage = Language.arabic;
      return const Locale(arabic, 'SA');
    default:
      AppInit.currentLanguage = Language.english;
      return const Locale(english, 'US');
  }
}

Future<void> setOnBoardingLocale(
  String languageCode,
) async {
  await setShowOnBoarding();
  await setLocaleLanguage(languageCode);
}

Future<void> setLocaleLanguage(String languageCode) async {
  showLoadingScreen();
  await Get.updateLocale(_locale(languageCode));
  await setLocale(languageCode);
  hideLoadingScreen();
}
