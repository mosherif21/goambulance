import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:goambulance/localization/language/language_functions.dart';
import 'package:goambulance/localization/language/localization_strings.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/error_widgets/not_available_error_widget.dart';
import 'package:goambulance/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:goambulance/src/utils/theme/theme.dart';

late Locale _locale;
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await AppInit.initialize();
  _locale = await getLocale();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return FlutterWebFrame(
      builder: (context) {
        return GetMaterialApp(
          translations: Languages(),
          locale: _locale != Get.deviceLocale ? _locale : Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: AppInit.showOnBoard
              ? const OnBoardingScreen()
              : const NotAvailableErrorWidget(),
        );
      },
      maximumSize: const Size(500.0, 812.0),
      enabled: AppInit.notWebMobile,
      backgroundColor: Colors.grey,
    );
  }
}
