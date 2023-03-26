import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../authentication/authentication_repository.dart';
import '../../localization/language/language_functions.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/home_screen/screens/home_screen.dart';
import 'common_widgets/language_select.dart';
import 'common_widgets/regular_bottom_sheet.dart';

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

void getToHomePage() => Get.offAll(() => const HomeScreen());

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
  required String title,
  required String body,
}) {
  ScaffoldMessenger.of(Get.context!).clearSnackBars();
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text('$title. $body.'),
      backgroundColor: const Color(0xFF28AADC),
      dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
  );
}

Future<void> logout() async {
  showLoadingScreen();
  await AuthenticationRepository.instance
      .logoutUser()
      .whenComplete(() => Get.offAll(() => const AuthenticationScreen()));
  hideLoadingScreen();
}

Future<void> displayChangeLang() async =>
    await RegularBottomSheet.showRegularBottomSheet(
      LanguageSelect(
        onEnglishLanguagePress: () async {
          await setLocaleLanguage('en');
          Get.back();
        },
        onArabicLanguagePress: () async {
          await setLocaleLanguage('ar');
          Get.back();
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
