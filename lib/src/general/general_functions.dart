import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';
import 'package:goambulance/src/features/ambulanceDriverFeatures/home_screen/controllers/employee_home_screen_controller.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../authentication/authentication_repository.dart';
import '../../firebase_files/firebase_patient_access.dart';
import '../../localization/language/language_functions.dart';
import '../connectivity/connectivity.dart';
import '../constants/assets_strings.dart';
import '../constants/enums.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/chat_bot/controllers/chat_bot_controller.dart';
import 'app_init.dart';
import 'common_widgets/language_select.dart';
import 'common_widgets/regular_bottom_sheet.dart';
import 'common_widgets/single_entry_screen.dart';

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

void showLoadingScreen() {
  final height = Get.context != null ? Get.context!.height : 200;
  Get.dialog(
    AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: WillPopScope(
        onWillPop: () async => false,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: LoadingAnimationWidget.inkDrop(
            color: Colors.white,
            size: height * 0.08,
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void makeSystemUiTransparent() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

void hideLoadingScreen() {
  Get.back();
}

bool isUserCritical() {
  return AuthenticationRepository.instance.criticalUserStatus.value ==
      CriticalUserStatus.criticalUserAccepted;
}

void showSnackBar({
  required String text,
  required SnackBarType snackBarType,
}) {
  if (Get.overlayContext != null) {
    final context = Get.overlayContext!;
    showTopSnackBar(
      Overlay.of(context),
      snackBarType == SnackBarType.success
          ? CustomSnackBar.success(
              message: text,
              icon: const Icon(Icons.check_circle_outline_rounded,
                  color: Color(0x15000000), size: 120),
            )
          : snackBarType == SnackBarType.error
              ? CustomSnackBar.error(
                  message: text,
                  icon: const Icon(Icons.error_outline,
                      color: Color(0x15000000), size: 120),
                )
              : CustomSnackBar.info(
                  message: text,
                  icon: const Icon(Icons.info_outline_rounded,
                      color: Color(0x15000000), size: 120),
                ),
    );
  }
}

void logoutDialogue() => displayAlertDialog(
      title: 'logout'.tr,
      body: 'logoutConfirm'.tr,
      positiveButtonText: 'yes'.tr,
      negativeButtonText: 'no'.tr,
      positiveButtonOnPressed: () => logout(),
      negativeButtonOnPressed: () => Get.back(),
      mainIcon: Icons.logout,
      color: SweetSheetColor.DANGER,
    );

void sendRequestSms(
    {required String requestId,
    required String patientName,
    required SosSmsType sosSmsType}) async {
  if (Get.isRegistered<FirebasePatientDataAccess>()) {
    final smsPermissionGranted = await Permission.sms.status.isGranted;
    if (smsPermissionGranted) {
      final contactsList =
          await FirebasePatientDataAccess.instance.getEmergencyContacts();
      String encodedSosRequestId = Uri.encodeFull(requestId);
      String trackingLink =
          "https://goambulance.help/tracking?requestId=$encodedSosRequestId";
      final sosMessage = sosSmsType == SosSmsType.normalRequestSMS
          ? 'normalSmsMsg'.trParams({
              'patientName': patientName,
              'trackingLink': trackingLink,
            })
          : 'sosSmsMsg'.trParams({
              'patientName': patientName,
              'trackingLink': trackingLink,
            });

      try {
        for (var contact in contactsList) {
          SmsStatus result = await BackgroundSms.sendMessage(
              phoneNumber: contact.contactNumber, message: sosMessage);
          if (kDebugMode) {
            if (result == SmsStatus.sent) {
              print("SMS sent with body: $sosMessage");
            } else {
              print("SMS failed");
            }
          }
        }
      } catch (err) {
        if (kDebugMode) {
          AppInit.logger.e('Request sms send error ${err.toString()}');
        }
      }
    }
  }
}

Future<void> logout() async {
  showLoadingScreen();
  if (AuthenticationRepository.instance.userType == UserType.patient) {
    if (Get.isRegistered<ChatBotController>()) {
      await Get.delete<ChatBotController>();
    }
    if (Get.isRegistered<HomeScreenController>()) {
      await HomeScreenController.instance.notificationCountStreamSubscription
          ?.cancel();
    }
    if (Get.isRegistered<FirebasePatientDataAccess>()) {
      await FirebasePatientDataAccess.instance.logoutFirebase();
    }
  } else {
    if (Get.isRegistered<EmployeeHomeScreenController>()) {
      await EmployeeHomeScreenController.instance.cancelListeners();
    }
    if (Get.isRegistered<FirebaseAmbulanceEmployeeDataAccess>()) {
      await FirebaseAmbulanceEmployeeDataAccess.instance.logoutFirebase();
    }
  }
  await AuthenticationRepository.instance.logoutAuthUser();
  hideLoadingScreen();
  Get.offAll(() => const AuthenticationScreen());
}

Future<void> textToSpeech({required String text}) async {
  final flutterTts = FlutterTts();

  await flutterTts.setLanguage(isLangEnglish() ? 'en' : 'ar');

  await flutterTts.speak(text);
}

void getToPhoneVerificationScreen(
        {required bool linkWithPhone, required bool goToInitPage}) =>
    Get.to(
      () => SingleEntryScreen(
        title: 'phoneVerification'.tr,
        prefixIconData: Icons.phone,
        lottieAssetAnim: kPhoneVerificationAnim,
        textFormTitle: 'phoneLabel'.tr,
        textFormHint: 'phoneFieldLabel'.tr,
        buttonTitle: 'continue'.tr,
        inputType: InputType.phone,
        linkWithPhone: linkWithPhone,
        goToInitPage: goToInitPage,
      ),
      transition: getPageTransition(),
    );

bool isLangEnglish() => AppInit.currentLanguage == Language.english;

void getOfAllPhoneVerificationScreen(
    {required bool linkWithPhone, required bool goToInitPage}) {
  ConnectivityChecker.checkConnection(displayAlert: true);
  Get.offAll(
    () => SingleEntryScreen(
      title: 'phoneVerification'.tr,
      prefixIconData: Icons.phone,
      lottieAssetAnim: kPhoneVerificationAnim,
      textFormTitle: 'phoneLabel'.tr,
      textFormHint: 'phoneFieldLabel'.tr,
      buttonTitle: 'continue'.tr,
      inputType: InputType.phone,
      linkWithPhone: linkWithPhone,
      goToInitPage: goToInitPage,
    ),
    transition: Transition.circularReveal,
  );
}

void callNumber({required String phoneNumber}) async {
  if (!AppInit.isWeb) {
    if (await handleCallPermission()) {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    }
  } else {
    showSnackBar(
        text: 'useMobileToThisFeature'.tr, snackBarType: SnackBarType.info);
  }
}

void displayAlertDialog({
  required String title,
  required String body,
  required CustomSheetColor color,
  required String positiveButtonText,
  String? negativeButtonText,
  required Function positiveButtonOnPressed,
  Function? negativeButtonOnPressed,
  IconData? mainIcon,
  IconData? positiveButtonIcon,
  IconData? negativeButtonIcon,
  bool? isDismissible,
}) {
  if (Get.context != null) {
    final SweetSheet sweetSheet = SweetSheet();
    final context = Get.context!;
    sweetSheet.show(
      isDismissible: isDismissible ?? true,
      context: context,
      title: Text(title),
      description: Text(body),
      color: color,
      icon: mainIcon,
      positive: SweetSheetAction(
        onPressed: () => positiveButtonOnPressed(),
        title: positiveButtonText,
        icon: positiveButtonIcon,
      ),
      negative: negativeButtonText != null
          ? SweetSheetAction(
              onPressed: () => negativeButtonOnPressed!(),
              title: negativeButtonText,
              icon: negativeButtonIcon,
            )
          : null,
    );
  }
}

Transition getPageTransition() {
  return AppInit.currentLanguage == Language.english
      ? Transition.rightToLeft
      : Transition.leftToRight;
}

void displayChangeLang() => RegularBottomSheet.showRegularBottomSheet(
      LanguageSelect(
        onEnglishLanguagePress: () {
          RegularBottomSheet.hideBottomSheet();
          setLocaleLanguage('en');
        },
        onArabicLanguagePress: () {
          RegularBottomSheet.hideBottomSheet();
          setLocaleLanguage('ar');
        },
      ),
    );

Future<bool> handleLocationPermission() async {
  try {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      return true;
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      return true;
    } else if (locationPermission == LocationPermission.denied) {
      showSnackBar(
          text: 'enableLocationPermission'.tr,
          snackBarType: SnackBarType.error);
    } else if (locationPermission == LocationPermission.deniedForever) {
      final deniedForeverText = 'locationPermissionDeniedForever'.tr;
      if (!AppInit.isWeb) {
        displayAlertDialog(
          title: 'locationPermission'.tr,
          body: deniedForeverText,
          positiveButtonText: 'goToSettings'.tr,
          negativeButtonText: 'cancel'.tr,
          positiveButtonOnPressed: () async {
            Get.back();
            if (!await Geolocator.openAppSettings()) {
              showSnackBar(
                  text: deniedForeverText, snackBarType: SnackBarType.error);
            }
          },
          negativeButtonOnPressed: () => Get.back(),
          mainIcon: Icons.settings,
          color: SweetSheetColor.WARNING,
        );
      } else {
        showSnackBar(text: deniedForeverText, snackBarType: SnackBarType.error);
      }
    }
  } catch (err) {
    if (kDebugMode) {
      AppInit.logger.e(err.toString());
    }
  }
  return false;
}

Future<bool> handleLocationService() async {
  try {
    final location = Location();
    if (await location.serviceEnabled()) {
      return true;
    } else {
      if (await location.requestService()) {
        return true;
      }
    }
  } catch (err) {
    if (kDebugMode) {
      AppInit.logger.e(err.toString());
    }
  }
  return false;
}

Future<void> handleLocation() async => await handleLocationService()
    .whenComplete(() async => await handleLocationPermission());

Future<bool> handleCameraPermission() async => await handleGeneralPermission(
      permission: Permission.camera,
      deniedSnackBarText: 'enableCameraPermission'.tr,
      deniedForeverSnackBarTitle: 'cameraPermission'.tr,
      deniedForeverSnackBarBody: 'cameraPermissionDeniedForever'.tr,
    );

Future<bool> handleMicrophonePermission() async =>
    await handleGeneralPermission(
      permission: Permission.microphone,
      deniedSnackBarText: 'enableMicPermission'.tr,
      deniedForeverSnackBarTitle: 'micPermission'.tr,
      deniedForeverSnackBarBody: 'micPermissionDeniedForever'.tr,
    );

Future<bool> handleContactsPermission() async => await handleGeneralPermission(
      permission: Permission.contacts,
      deniedSnackBarText: 'enableContactsPermission'.tr,
      deniedForeverSnackBarTitle: 'contactsPermission'.tr,
      deniedForeverSnackBarBody: 'contactsPermissionDeniedForever'.tr,
    );

Future<bool> handleCallPermission() async => await handleGeneralPermission(
      permission: Permission.phone,
      deniedSnackBarText: 'enableCallPermission'.tr,
      deniedForeverSnackBarTitle: 'callPermission'.tr,
      deniedForeverSnackBarBody: 'callPermissionDeniedForever'.tr,
    );

Future<bool> handleStoragePermission() async => await handleGeneralPermission(
      permission: Permission.storage,
      deniedSnackBarText: 'enableStoragePermission'.tr,
      deniedForeverSnackBarTitle: 'storagePermission'.tr,
      deniedForeverSnackBarBody: 'storagePermissionDeniedForever'.tr,
    );
Future<bool> handleSmsPermission() async => await handleGeneralPermission(
      permission: Permission.sms,
      deniedSnackBarText: 'enableSmsPermission'.tr,
      deniedForeverSnackBarTitle: 'smsPermission'.tr,
      deniedForeverSnackBarBody: 'smsPermissionDeniedForever'.tr,
    );
Future<bool> handleNotificationsPermission() async =>
    await handleGeneralPermission(
      permission: Permission.notification,
      deniedSnackBarText: 'enableNotificationPermission'.tr,
      deniedForeverSnackBarTitle: 'notificationsPermission'.tr,
      deniedForeverSnackBarBody: 'notificationsPermissionDeniedForever'.tr,
    );
Future<bool> handleSpeechPermission() async => await handleGeneralPermission(
      permission: Permission.speech,
      deniedSnackBarText: 'enableSpeechPermission'.tr,
      deniedForeverSnackBarTitle: 'speechPermission'.tr,
      deniedForeverSnackBarBody: 'speechPermissionDeniedForever'.tr,
    );
Future<bool> handleAndroidBatteryPermission() async =>
    await handleGeneralPermission(
      permission: Permission.ignoreBatteryOptimizations,
      deniedSnackBarText: '',
      deniedForeverSnackBarTitle: '',
      deniedForeverSnackBarBody: '',
    );

Future<bool> handleGeneralPermission({
  required Permission permission,
  required String deniedSnackBarText,
  required String deniedForeverSnackBarTitle,
  required String deniedForeverSnackBarBody,
}) async {
  if (!AppInit.isWeb) {
    try {
      var permissionStatus = await permission.status;
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied) {
        permissionStatus = await permission.request();
      }

      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied) {
        showSnackBar(
            text: deniedSnackBarText, snackBarType: SnackBarType.error);
      } else if (permissionStatus.isPermanentlyDenied) {
        displayAlertDialog(
          title: deniedForeverSnackBarTitle,
          body: deniedForeverSnackBarBody,
          positiveButtonText: 'goToSettings'.tr,
          negativeButtonText: 'cancel'.tr,
          positiveButtonOnPressed: () async {
            Get.back();
            if (!await openAppSettings()) {
              showSnackBar(
                  text: deniedForeverSnackBarBody,
                  snackBarType: SnackBarType.error);
            }
          },
          negativeButtonOnPressed: () => Get.back(),
          mainIcon: Icons.settings,
          color: SweetSheetColor.WARNING,
        );
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
  }
  return false;
}

void getToResetPasswordScreen() {
  Get.to(
    () => SingleEntryScreen(
      title: 'passwordResetLink'.tr,
      prefixIconData: Icons.email_outlined,
      lottieAssetAnim: kEmailVerificationAnim,
      textFormTitle: 'emailLabel'.tr,
      textFormHint: 'emailHintLabel'.tr,
      buttonTitle: 'confirm'.tr,
      inputType: InputType.email,
      linkWithPhone: false,
      goToInitPage: false,
    ),
    transition: getPageTransition(),
  );
}

String formatDateTime(Timestamp timestamp) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  DateFormat formatter = DateFormat('MMM d y hh:mm a');
  return formatter.format(dateTime);
}

String getAddedCurrentTime({required int minutesToAdd}) {
  DateTime currentTime = DateTime.now();
  DateTime newTime = currentTime.add(Duration(minutes: minutesToAdd));
  return DateFormat.jm().format(newTime);
}

String getMinutesString(int minutes) {
  return minutes == 1
      ? 'minute'.tr
      : minutes == 2
          ? isLangEnglish()
              ? 'minutes'.tr
              : 'minute'.tr
          : minutes > 2 && minutes <= 10
              ? 'minutes'.tr
              : isLangEnglish()
                  ? 'minutes'.tr
                  : 'minute'.tr;
}
