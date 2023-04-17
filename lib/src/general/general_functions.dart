import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_patient_access.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart' as loc;
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../authentication/authentication_repository.dart';
import '../../localization/language/language_functions.dart';
import '../connectivity/connectivity.dart';
import '../constants/app_init_constants.dart';
import '../constants/assets_strings.dart';
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
}) {
  ScaffoldMessenger.of(Get.context!).clearSnackBars();
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text('$text.'),
      backgroundColor: kDefaultColor,
      //dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
  );
}

Future<void> logout() async {
  displayBinaryAlertDialog(
    title: 'logout'.tr,
    body: 'logoutConfirm'.tr,
    positiveButtonText: 'yes'.tr,
    negativeButtonText: 'no'.tr,
    positiveButtonOnPressed: () async {
      showLoadingScreen();
      await AuthenticationRepository.instance.logoutUser();
      if (Get.isRegistered<FirebasePatientDataAccess>()) {
        await FirebasePatientDataAccess.instance.logoutFirebase();
      }
      if (kDebugMode) print('signing out');
      Get.offAll(() => const AuthenticationScreen());
      hideLoadingScreen();
    },
    negativeButtonOnPressed: () => Get.back(),
    positiveButtonIcon: Icons.logout,
    negativeButtonIcon: Icons.cancel_outlined,
  );
}

void getToPhoneVerificationScreen() {
  Get.to(
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
    transition: AppInit.getPageTransition(),
  );
}

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

void displayBinaryAlertDialog({
  required String title,
  required String body,
  required String positiveButtonText,
  required String negativeButtonText,
  required Function positiveButtonOnPressed,
  required Function negativeButtonOnPressed,
  required IconData positiveButtonIcon,
  required IconData negativeButtonIcon,
}) async {
  Dialogs.materialDialog(
      title: title,
      msg: body,
      color: Colors.white,
      context: Get.context!,
      actions: [
        IconsButton(
          onPressed: () => positiveButtonOnPressed(),
          text: positiveButtonText,
          iconData: positiveButtonIcon,
          color: kDefaultColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsOutlineButton(
          onPressed: () => negativeButtonOnPressed(),
          text: negativeButtonText,
          iconData: negativeButtonIcon,
          textStyle: const TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
      ]);
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
Future<bool> handleLocationPermission() async => await handleGeneralPermission(
      permission: Permission.location,
      deniedSnackBarText: 'enableLocationPermission'.tr,
      deniedForeverSnackBarTitle: 'locationPermission'.tr,
      deniedForeverSnackBarBody: 'locationPermissionDeniedForever'.tr,
    );
Future<bool> handleLocationService() async {
  try {
    final location = loc.Location();
    if (await location.serviceEnabled()) {
      return true;
    } else {
      await location.requestService();
    }
    if (await location.serviceEnabled()) return true;
  } catch (err) {
    if (kDebugMode) print(err.toString());
  }
  return false;
}

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

// Future<bool> handleStoragePermission() async => await handleGeneralPermission(
//       permission: Permission.storage,
//       deniedSnackBarText: 'enableStoragePermission'.tr,
//       deniedForeverSnackBarTitle: 'storagePermission'.tr,
//       deniedForeverSnackBarBody: 'storagePermissionDeniedForever'.tr,
//     );

Future<bool> handleGeneralPermission({
  required Permission permission,
  required String deniedSnackBarText,
  required String deniedForeverSnackBarTitle,
  required String deniedForeverSnackBarBody,
}) async {
  try {
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus.isGranted) {
      return true;
    } else if (permissionStatus.isDenied) {
      permissionStatus = await permission.request();
    }

    if (permissionStatus.isGranted) {
      return true;
    } else if (permissionStatus.isDenied) {
      showSimpleSnackBar(text: deniedSnackBarText);
    } else if (permissionStatus.isPermanentlyDenied) {
      displayBinaryAlertDialog(
        title: deniedForeverSnackBarTitle,
        body: deniedForeverSnackBarBody,
        positiveButtonText: 'goToSettings'.tr,
        negativeButtonText: 'cancel'.tr,
        positiveButtonOnPressed: () async {
          Get.back();
          if (!await openAppSettings()) {
            showSimpleSnackBar(text: deniedForeverSnackBarBody);
          }
        },
        negativeButtonOnPressed: () {
          Get.back();
          showSimpleSnackBar(text: deniedForeverSnackBarBody);
        },
        positiveButtonIcon: Icons.settings,
        negativeButtonIcon: Icons.cancel_outlined,
      );
    }
  } catch (err) {
    if (kDebugMode) print(err.toString());
  }
  return false;
}
