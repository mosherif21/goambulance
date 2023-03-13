import 'package:goambulance/src/general/common_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../localization/language/language_functions.dart';
import '../../../constants/app_init_constants.dart';

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
  showLoadingScreen();
  await setOnBoardingLocale(languageCode)
      .whenComplete(() => AppInit.onBoardingPageNavigation());
}
