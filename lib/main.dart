import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:goambulance/localization/language/localization_strings.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/utils/theme/theme.dart';

void main() async {
  await AppInit.initialize().whenComplete(
    () => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return GetMaterialApp(
          translations: Languages(),
          locale: AppInit.setLocale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: AppInit.getInitialPage(),
        );
      },
      maximumSize: const Size(500.0, 812.0), // Maximum size
      enabled: AppInit.notWebMobile,
      backgroundColor: Colors.grey.shade500,
    );
  }
}
