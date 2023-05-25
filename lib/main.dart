import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:goambulance/localization/language/localization_strings.dart';
import 'package:goambulance/src/connectivity/connectivity_controller.dart';
import 'package:goambulance/src/general/app_init.dart';
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
    Get.put(ConnectivityController());
    return FlutterWebFrame(
      builder: (context) {
        return GetMaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: NonScrollPhysics(),
              child: child!,
            );
          },
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

class NonScrollPhysics extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
