import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../authentication/authentication_repository.dart';
import '../../localization/language/language_functions.dart';
import '../connectivity/connectivity.dart';
import '../constants/app_init_constants.dart';
import '../constants/assets_strings.dart';
import '../constants/enums.dart';
import '../features/authentication/screens/auth_screen.dart';
import 'common_widgets/language_select.dart';
import 'common_widgets/regular_bottom_sheet.dart';
import 'common_widgets/single_entry_screen.dart';

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

void showLoadingScreen() {
  final height = Get.context?.height;
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
            size: height! * 0.08,
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

bool isUserCritical() {
  return AuthenticationRepository.instance.userType == UserType.criticalUser
      ? true
      : false;
}

void hideLoadingScreen() {
  Get.back();
}

void showSimpleSnackBar({
  required String text,
  required SnackBarType snackBarType,
}) {
  final context = Get.context!;
  AnimatedSnackBar.material(
    text,
    type: snackBarType == SnackBarType.success
        ? AnimatedSnackBarType.success
        : snackBarType == SnackBarType.error
            ? AnimatedSnackBarType.error
            : AnimatedSnackBarType.info,
    snackBarStrategy: RemoveSnackBarStrategy(),
    duration: const Duration(seconds: 5),
  ).show(context);
}

void logoutDialogue() async => displayAlertDialog(
      title: 'logout'.tr,
      body: 'logoutConfirm'.tr,
      positiveButtonText: 'yes'.tr,
      negativeButtonText: 'no'.tr,
      positiveButtonOnPressed: () async => await logout(),
      negativeButtonOnPressed: () => Get.back(),
      mainIcon: Icons.logout,
      color: SweetSheetColor.DANGER,
    );

Future<void> logout() async {
  showLoadingScreen();
  await AuthenticationRepository.instance.logoutUser();
  if (Get.isRegistered<FirebasePatientDataAccess>()) {
    await FirebasePatientDataAccess.instance.logoutFirebase();
  }
  if (kDebugMode) print('signing out');
  Get.offAll(() => const AuthenticationScreen());
  hideLoadingScreen();
}

void getToPhoneVerificationScreen() => Get.to(
      () => SingleEntryScreen(
        title: 'phoneVerification'.tr,
        prefixIconData: Icons.phone,
        lottieAssetAnim: kPhoneVerificationAnim,
        textFormTitle: 'phoneLabel'.tr,
        textFormHint: 'phoneFieldLabel'.tr,
        buttonTitle: 'continue'.tr,
        inputType: InputType.phone,
        linkWithPhone: false,
      ),
      transition: getPageTransition(),
    );

bool isLangEnglish() => AppInit.currentLanguage == Language.english;
void getOfAllPhoneVerificationScreen() {
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
      linkWithPhone: true,
    ),
    transition: Transition.circularReveal,
  );
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
}) {
  final SweetSheet sweetSheet = SweetSheet();
  final context = Get.context!;
  sweetSheet.show(
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

Future<void> displayChangeLang() async =>
    await RegularBottomSheet.showRegularBottomSheet(
      LanguageSelect(
        onEnglishLanguagePress: () async {
          await setLocaleLanguage('en');
          RegularBottomSheet.hideBottomSheet();
        },
        onArabicLanguagePress: () async {
          await setLocaleLanguage('ar');
          RegularBottomSheet.hideBottomSheet();
        },
      ),
    );

Future<bool> handleLocationPermission({required bool showSnackBar}) async {
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
      if (showSnackBar) {
        showSimpleSnackBar(
            text: 'enableLocationPermission'.tr,
            snackBarType: SnackBarType.error);
      }
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
              if (showSnackBar) {
                showSimpleSnackBar(
                    text: deniedForeverText, snackBarType: SnackBarType.error);
              }
            }
          },
          negativeButtonOnPressed: () {
            Get.back();
            if (showSnackBar) {
              showSimpleSnackBar(
                  text: deniedForeverText, snackBarType: SnackBarType.error);
            }
          },
          mainIcon: Icons.settings,
          color: SweetSheetColor.WARNING,
        );
      } else {
        if (showSnackBar) {
          showSimpleSnackBar(
              text: deniedForeverText, snackBarType: SnackBarType.error);
        }
      }
    }
  } catch (err) {
    if (kDebugMode) print(err.toString());
  }
  return false;
}

Transition getPageTransition() {
  return AppInit.currentLanguage == Language.english
      ? Transition.rightToLeft
      : Transition.leftToRight;
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
    if (kDebugMode) print(err.toString());
  }
  return false;
}

Future<void> handleLocation({required bool showSnackBar}) async =>
    await handleLocationService().whenComplete(
        () async => await handleLocationPermission(showSnackBar: showSnackBar));

Future<bool> handleCameraPermission({required bool showSnackBar}) async =>
    await handleGeneralPermission(
      permission: Permission.camera,
      deniedSnackBarText: 'enableCameraPermission'.tr,
      deniedForeverSnackBarTitle: 'cameraPermission'.tr,
      deniedForeverSnackBarBody: 'cameraPermissionDeniedForever'.tr,
      showSnackBar: showSnackBar,
    );

Future<bool> handleMicrophonePermission({required bool showSnackBar}) async =>
    await handleGeneralPermission(
      permission: Permission.microphone,
      deniedSnackBarText: 'enableMicPermission'.tr,
      deniedForeverSnackBarTitle: 'micPermission'.tr,
      deniedForeverSnackBarBody: 'micPermissionDeniedForever'.tr,
      showSnackBar: showSnackBar,
    );

Future<bool> handleContactsPermission({required bool showSnackBar}) async =>
    await handleGeneralPermission(
      permission: Permission.contacts,
      deniedSnackBarText: 'enableContactsPermission'.tr,
      deniedForeverSnackBarTitle: 'contactsPermission'.tr,
      deniedForeverSnackBarBody: 'contactsPermissionDeniedForever'.tr,
      showSnackBar: showSnackBar,
    );

Future<bool> handleCallPermission({required bool showSnackBar}) async =>
    await handleGeneralPermission(
      permission: Permission.phone,
      deniedSnackBarText: 'enableCallPermission'.tr,
      deniedForeverSnackBarTitle: 'callPermission'.tr,
      deniedForeverSnackBarBody: 'callPermissionDeniedForever'.tr,
      showSnackBar: showSnackBar,
    );

Future<bool> handleStoragePermission({required bool showSnackBar}) async =>
    await handleGeneralPermission(
      permission: Permission.storage,
      deniedSnackBarText: 'enableStoragePermission'.tr,
      deniedForeverSnackBarTitle: 'storagePermission'.tr,
      deniedForeverSnackBarBody: 'storagePermissionDeniedForever'.tr,
      showSnackBar: showSnackBar,
    );

Future<bool> handleGeneralPermission({
  required Permission permission,
  required String deniedSnackBarText,
  required String deniedForeverSnackBarTitle,
  required String deniedForeverSnackBarBody,
  required bool showSnackBar,
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
        showSimpleSnackBar(
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
              if (showSnackBar) {
                showSimpleSnackBar(
                    text: deniedForeverSnackBarBody,
                    snackBarType: SnackBarType.error);
              }
            }
          },
          negativeButtonOnPressed: () {
            Get.back();
            if (showSnackBar) {
              showSimpleSnackBar(
                  text: deniedForeverSnackBarBody,
                  snackBarType: SnackBarType.error);
            }
          },
          mainIcon: Icons.settings,
          color: SweetSheetColor.WARNING,
        );
      }
    } catch (err) {
      if (kDebugMode) print(err.toString());
    }
  }
  return false;
}
