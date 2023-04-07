import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_access.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../authentication/authentication_repository.dart';
import '../../localization/language/language_functions.dart';
import '../features/authentication/screens/auth_screen.dart';
import 'common_widgets/language_select.dart';
import 'common_widgets/regular_bottom_sheet.dart';

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
      backgroundColor: const Color(0xEE28AADC),
      //dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
  );
}

Future<void> logout() async {
  await displayBinaryAlertDialog(
      title: 'logout'.tr,
      body: 'logoutConfirm'.tr,
      positiveButtonText: 'yes'.tr,
      negativeButtonText: 'no'.tr,
      positiveButtonOnPressed: () async {
        showLoadingScreen();
        await AuthenticationRepository.instance.logoutUser();
        await FirebaseDataAccess.instance.logoutFirebase();
        if (kDebugMode) print('signing out');
        Get.offAll(() => const AuthenticationScreen());
        hideLoadingScreen();
      },
      negativeButtonOnPressed: () => Get.back());
}

Future<void> displayBinaryAlertDialog({
  required String title,
  required String body,
  required String positiveButtonText,
  required String negativeButtonText,
  required Function positiveButtonOnPressed,
  required Function negativeButtonOnPressed,
}) async {
  await Dialogs.materialDialog(
      title: title,
      msg: body,
      color: Colors.white,
      context: Get.context!,
      actions: [
        IconsButton(
          onPressed: () async => await positiveButtonOnPressed(),
          text: positiveButtonText,
          iconData: Icons.logout,
          color: kDefaultColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsOutlineButton(
          onPressed: () async => await negativeButtonOnPressed(),
          text: negativeButtonText,
          iconData: Icons.cancel_outlined,
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

//SnackbarStatus snackBarStatus = SnackbarStatus.CLOSED;
//
// void showFloatingSnackBar(
//     {required String title,
//     required String body,
//     required SnackPosition position}) {
//   Get.snackbar(title, body,
//       colorText: Colors.black,
//       snackPosition: position,
//       snackbarStatus: (snackStatusCallBack) =>
//           snackBarStatus = snackStatusCallBack!,
//       barBlur: 20.0,
//       margin: const EdgeInsets.all(20.0));
// }

// void showAwesomeSnackbar(
//     {required String title,
//     required String body,
//     required ContentType contentType}) {
//   ScaffoldMessenger.of(Get.context!)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(
//       SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: title,
//           message: body,
//           contentType: contentType,
//         ),
//       ),
//     );
// }
