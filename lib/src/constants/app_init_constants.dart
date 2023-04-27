import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/intro_screen/screens/intro_screen.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../authentication/authentication_repository.dart';
import '../../firebase_files/firebase_initializations.dart';
import '../../localization/language/language_functions.dart';
import '../features/account/components/newAccount/register_user_data_page.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/home_screen/screens/home_screen.dart';
import '../features/intro_screen/components/onboarding_shared_preferences.dart';
import '../features/intro_screen/screens/on_boarding_screen.dart';
import '../general/common_widgets/empty_scaffold.dart';
import '../general/error_widgets/no_internet_error_widget.dart';
import 'colors.dart';
import 'enums.dart';

class AppInit {
  static bool showOnBoard = false;
  static bool notWebMobile = false;
  static bool isWeb = false;
  static bool isAndroid = false;
  static bool isIos = false;
  static bool webMobile = false;
  static bool isInitialised = false;
  static bool isConstantsInitialised = false;
  static bool splashRemoved = false;
  static late SharedPreferences prefs;
  static bool isLocaleSet = false;
  static late final Locale setLocale;
  static Language currentLanguage = Language.english;
  static InternetConnectionStatus initialInternetConnectionStatus =
      InternetConnectionStatus.disconnected;
  static Transition transition = Transition.leftToRightWithFade;
  static late final String? notificationToken;

  static final currentAuthType = AuthType.emailLogin.obs;

  static Future<void> initializeConstants() async {
    if (!isConstantsInitialised) {
      prefs = await SharedPreferences.getInstance();
      isLocaleSet = await getIfLocaleIsSet();
      showOnBoard = await getShowOnBoarding();
      if (isLocaleSet) {
        setLocale = getLocale();
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
      SweetSheetColor.NICE = CustomSheetColor(
          main: const Color(0xEE28AADC),
          accent: kDefaultColor,
          icon: Colors.white);
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
      //await initializeNotification();
      Get.put(AuthenticationRepository(), permanent: true);
    }
  }

  static Future<void> initialize() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await initializeConstants();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> internetInitialize() async {
    if (!isInitialised) {
      AppInit.initializeDatabase().whenComplete(() async {
        if (!showOnBoard) {
          await goToInitPage();
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

  static void onBoardingPageNavigation() {
    showOnBoard = false;
    if (!isInitialised) {
      Get.offAll(() => const NotInternetErrorWidget());
    } else {
      goToInitPage();
    }
  }

  static Future<void> goToInitPage() async {
    final authRepo = AuthenticationRepository.instance;
    if (AuthenticationRepository.instance.isUserLoggedIn) {
      final functionStatus = await AuthenticationRepository.instance.userInit();
      removeSplashScreen();
      if (functionStatus == FunctionStatus.success) {
        if (authRepo.userType == UserType.driver ||
            authRepo.userType == UserType.medic) {
          Get.offAll(
            () => const HomeScreen(),
            transition: Transition.circularReveal,
          );
        } else if (authRepo.userType == UserType.regularUser ||
            authRepo.userType == UserType.criticalUser) {
          if (!authRepo.isUserPhoneRegistered && !authRepo.isUserRegistered) {
            getOfAllPhoneVerificationScreen();
          } else if (authRepo.isUserPhoneRegistered &&
              !authRepo.isUserRegistered) {
            if (AppInit.isWeb) {
              await authRepo.logoutUser();
              Get.offAll(() => const AuthenticationScreen());
              showSnackBar(
                  text: 'useMobileToRegister'.tr,
                  snackBarType: SnackBarType.info);
            } else {
              Get.offAll(() => const RegisterUserDataPage(),
                  transition: Transition.circularReveal);
            }
          } else if (authRepo.isUserPhoneRegistered &&
              authRepo.isUserRegistered) {
            SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.transparent,
                statusBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
            );
            Get.offAll(() => const HomeScreen(),
                transition: Transition.circularReveal);
          }
        }
      } else {
        hideLoadingScreen();
        removeSplashScreen();
        await authRepo.logoutUser();
        showSnackBar(text: 'loginFailed'.tr, snackBarType: SnackBarType.error);
      }
    } else {
      removeSplashScreen();
      await Get.offAll(
        () => const IntroScreen(),
        transition: Transition.circularReveal,
      );
    }
  }

  static Widget getInitialPage() {
    if (showOnBoard) removeSplashScreen();
    return showOnBoard ? const OnBoardingScreen() : const EmptyScaffold();
  }

  static void removeSplashScreen() {
    if (!splashRemoved) {
      FlutterNativeSplash.remove();
      splashRemoved = true;
    }
  }
}
