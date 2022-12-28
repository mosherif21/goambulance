import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:goambulance/localization/language/localization_strings.dart';
import 'package:goambulance/src/connectivity/connectivity_controller.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/authentication/screens/login_screen.dart';
import 'package:goambulance/src/features/home_page/screens/home_page_screen.dart';
import 'package:goambulance/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:goambulance/src/general/notifications.dart';
import 'package:goambulance/src/routing/splash_screen.dart';
import 'package:goambulance/src/utils/theme/theme.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'authentication/authentication_repository.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppInit.initializeConstants();
  Get.put(ConnectivityController());
  final internetConnectionStatus =
      await InternetConnectionCheckerPlus().connectionStatus;
  if (internetConnectionStatus == InternetConnectionStatus.connected) {
    await AppInit.initialize();
  }

  await initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppInit.showOnBoard) removeSplashScreen();
    return FlutterWebFrame(
      builder: (context) {
        return GetMaterialApp(
          translations: Languages(),
          locale: AppInit.setLocale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: AppInit.showOnBoard
              ? const OnBoardingScreen()
              : AuthenticationRepository.instance.isUserLoggedIn
                  ? const HomePageScreen()
                  : const LoginScreen(),
        );
      },
      maximumSize: const Size(500.0, 812.0),
      enabled: AppInit.notWebMobile,
      backgroundColor: Colors.white,
    );
  }
}
