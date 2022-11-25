import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String languageCode = 'languageCode';

//languages code
const String english = 'en';
const String arabic = 'ar';

//to update locale by user use following code: { Get.updateLocale(const Locale('ar', 'SA'));
// setLocale('ar');}

Future<void> setLocale(String aLanguageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageCode, aLanguageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String aLanguageCode = prefs.getString(languageCode) ?? english;
  return _locale(aLanguageCode);
}

Locale _locale(String aLanguageCode) {
  switch (aLanguageCode) {
    case english:
      return const Locale(english, 'US');
    case arabic:
      return const Locale(arabic, 'SA');
    default:
      return const Locale(english, 'US');
  }
}
