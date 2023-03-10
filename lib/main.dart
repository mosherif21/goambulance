import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/localization/language/localization_strings.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/utils/theme/theme.dart';

void main() {
  AppInit.initialize().whenComplete(
    () => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: AppInit.setLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AppInit.getInitialPage(),
    );
  }
}
