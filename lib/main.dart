import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/localization/language/localization_strings.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/authentication/screens/auth_screen.dart';
import 'package:goambulance/src/features/home_page/screens/home_page_screen.dart';
import 'package:goambulance/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:goambulance/src/general/error_widgets/no_internet_error_widget.dart';
import 'package:goambulance/src/utils/theme/theme.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'authentication/authentication_repository.dart';

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
      home: AppInit.showOnBoard
          ? const OnBoardingScreen()
          : AppInit.initialInternetConnectionStatus ==
                  InternetConnectionStatus.disconnected
              ? const NotInternetErrorWidget()
              : AuthenticationRepository.instance.isUserLoggedIn
                  ? const HomePageScreen()
                  : const AuthenticationScreen(),
    );
  }
}
