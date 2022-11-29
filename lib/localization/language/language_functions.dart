import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/constants/app_init_constants.dart';
import '../../src/features/onboarding/components/onboarding_shared_preferences.dart';

const String languageCode = 'languageCode';

//languages code
const String english = 'en';
const String arabic = 'ar';

//to update locale by user use following code: { Get.updateLocale(const Locale('ar', 'SA'));
// setLocale('ar');}

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

Future<Locale> getLocale() async {
  String? aLanguageCode = AppInit.prefs.getString(languageCode);
  return _locale(aLanguageCode!);
}

Locale _locale(String aLanguageCode) {
  switch (aLanguageCode) {
    case english:
      AppInit.currentDeviceLanguage = Language.english;
      return const Locale(english, 'US');
    case arabic:
      AppInit.currentDeviceLanguage = Language.arabic;
      return const Locale(arabic, 'SA');
    default:
      AppInit.currentDeviceLanguage = Language.english;
      return const Locale(english, 'US');
  }
}

Future<void> setOnBoardingLocale(
  String languageCode,
) async {
  await setShowOnBoarding();
  await Get.updateLocale(_locale(languageCode));
  await setLocale(languageCode);
}
