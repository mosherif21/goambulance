import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/authentication_repository.dart';
import '../../firebase_files/firebase_initializations.dart';
import '../../localization/language/language_functions.dart';
import '../connectivity/connectivity_controller.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/home_page/screens/home_screen.dart';
import '../features/onboarding/components/onboarding_shared_preferences.dart';
import '../features/onboarding/screens/on_boarding_screen.dart';
import '../general/common_widgets/empty_scaffold.dart';
import '../general/error_widgets/no_internet_error_widget.dart';
import '../general/notifications.dart';
import '../general/splash_screen.dart';

enum Language { english, arabic }

enum InputType { email, phone, text }

enum ScreenSize { small, medium, large }

enum AuthType {
  emailLogin,
  emailRegister,
  facebook,
  google,
  phone,
}

class AppInit {
  static bool showOnBoard = false;
  static bool notWebMobile = false;
  static bool isWeb = false;
  static bool isAndroid = false;
  static bool isIos = false;
  static bool webMobile = false;
  static bool isInitialised = false;
  static bool isConstantsInitialised = false;
  static late SharedPreferences prefs;
  static bool isLocaleSet = false;
  static late final Locale setLocale;
  static Language currentDeviceLanguage = Language.english;
  static InternetConnectionStatus initialInternetConnectionStatus =
      InternetConnectionStatus.disconnected;
  static Transition transition = Transition.leftToRightWithFade;
  // ignore: prefer_typing_uninitialized_variables
  static late final notificationToken;

  static final currentAuthType = AuthType.emailLogin.obs;

  static const _breakPoint1 = 600.0;
  static const _breakPoint2 = 840.0;

  static ScreenSize getScreenSize(double width) {
    if (width < _breakPoint1) {
      return ScreenSize.small;
    } else if (width >= _breakPoint1 && width <= _breakPoint2) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.large;
    }
  }

  static Future<void> initializeConstants() async {
    if (!isConstantsInitialised) {
      prefs = await SharedPreferences.getInstance();
      isLocaleSet = await getIfLocaleIsSet();
      showOnBoard = await getShowOnBoarding();
      if (isLocaleSet) {
        setLocale = await getLocale();
      } else {
        setLocale = Get.deviceLocale ?? const Locale('en', 'US');
      }
      isWeb = kIsWeb;
      notWebMobile = isWeb &&
          !(defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android);

      webMobile = isWeb &&
          (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android);

      if (defaultTargetPlatform == TargetPlatform.android && !isWeb) {
        isAndroid = true;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS && !isWeb) {
        isIos = true;
      }
      isConstantsInitialised = true;
    }
  }

  static Future<void> initializeDatabase() async {
    if (!isInitialised) {
      isInitialised = true;
      await initializeFireBaseApp();
      if (kDebugMode) print('firebase app initialized');
      if (isWeb || webMobile) {
        await activateWebAppCheck();
        if (kDebugMode) print('web app check initialized');
      } else if (isAndroid) {
        await activateAndroidAppCheck();
        if (kDebugMode) print('android app check initialized');
      } else if (isIos) {
        await activateIosAppCheck();
        if (kDebugMode) print('ios app check initialized');
      }
      if (kDebugMode) print('Firebase initialized');
      if (!isWeb) {
        notificationToken = await FirebaseMessaging.instance.getToken();
      }
      await initializeNotification();
      Get.put(AuthenticationRepository(), permanent: true);
    }
  }

  static Future<void> initialize() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await initializeConstants();
    Get.put(ConnectivityController());

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> internetInitialize() async {
    if (!isInitialised) {
      AppInit.initializeDatabase().whenComplete(() async {
        if (!showOnBoard) {
          removeSplashScreen();
          await goToAuthenticationOrHomePage();
        }
      });
    }
  }

  static Future<void> noInternetInitializeCheck() async {
    if (!isInitialised) {
      removeSplashScreen();
      if (!showOnBoard) Get.offAll(() => const NotInternetErrorWidget());
    }
  }

  static Future<void> onBoardingPageNavigation() async {
    showOnBoard = false;
    if (!isInitialised) {
      Get.offAll(() => const NotInternetErrorWidget());
    } else {
      await goToAuthenticationOrHomePage();
    }
  }

  static Future<void> goToAuthenticationOrHomePage() async {
    AuthenticationRepository.instance.isUserLoggedIn
        ? await Get.offAll(() => const HomeScreen(),
            transition: Transition.noTransition)
        : await Get.offAll(() => const AuthenticationScreen(),
            transition: Transition.noTransition);
  }

  static Widget? getInitialPage() {
    if (showOnBoard) removeSplashScreen();
    return showOnBoard ? const OnBoardingScreen() : const EmptyScaffold();
  }

  static Transition getPageTransition() {
    return currentDeviceLanguage == Language.english
        ? Transition.rightToLeftWithFade
        : Transition.leftToRightWithFade;
  }
}
