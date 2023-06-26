import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';

import '../../src/constants/enums.dart';
import '../../src/features/home_screen/controllers/home_screen_controller.dart';
import '../../src/features/intro_screen/components/onboarding_shared_preferences.dart';
import '../../src/features/requests/controllers/requests_history_controller.dart';
import '../../src/general/app_init.dart';
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
  if (Get.locale!.languageCode != languageCode) {
    showLoadingScreen();
    await Get.updateLocale(_locale(languageCode));
    await setLocale(languageCode);
    if (Get.isRegistered<FirebasePatientDataAccess>() &&
        AppInit.notificationToken.isNotEmpty) {
      FirebasePatientDataAccess.instance.updateCurrentLanguage();
    }
    if (Get.isRegistered<HomeScreenController>()) {
      if (Get.isRegistered<RequestsHistoryController>()) {
        if (HomeScreenController.instance.navBarIndex.value == 1) {
          RequestsHistoryController.instance.getRequestsHistory();
        }
      }
    }
    hideLoadingScreen();
  }
}
