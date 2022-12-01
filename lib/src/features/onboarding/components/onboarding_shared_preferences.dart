//--Shared Preferences Functions
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../localization/language/language_functions.dart';
import '../../../routing/loading_screen.dart';
import '../../login/screens/login_screen.dart';

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

Future<void> setLocaleLanguage(String languageCode) async {
  showLoadingScreen();
  await setOnBoardingLocale(languageCode);
  hideLoadingScreen();
  Get.offAll(() => const LoginScreen());
}
