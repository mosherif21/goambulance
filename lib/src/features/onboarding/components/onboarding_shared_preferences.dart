//--Shared Preferences Functions
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../localization/language/language_functions.dart';
import '../../../general/common_functions.dart';
import '../../authentication/screens/auth_screen.dart';

late SharedPreferences _prefs;
Future<void> setShowOnBoarding() async {
  _prefs = await SharedPreferences.getInstance();
  await _prefs.setString("onboarding", "true");
}

Future<bool> getShowOnBoarding() async {
  _prefs = await SharedPreferences.getInstance();
  if (_prefs.getString("onboarding")?.compareTo("true") == 0) {
    return false;
  } else {
    return true;
  }
}

Future<void> setOnBoardingLocaleLanguage(String languageCode) async {
  await showLoadingScreen().whenComplete(() async {
    await setOnBoardingLocale(languageCode);
    hideLoadingScreen();
    Get.offAll(
      () => const AuthenticationScreen(),
      transition: AppInit.getPageTransition(),
    );
  });
}
