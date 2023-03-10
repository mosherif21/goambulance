import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

void getToHomePage() => Get.offAll(() => const HomePageScreen());

SnackbarStatus snackBarStatus = SnackbarStatus.CLOSED;
void showFloatingSnackBar(
    {required String title,
    required String body,
    required SnackPosition position}) {
  Get.snackbar(title, body,
      colorText: Colors.black,
      snackPosition: position,
      snackbarStatus: (snackStatusCallBack) =>
          snackBarStatus = snackStatusCallBack!,
      barBlur: 20.0,
      margin: const EdgeInsets.all(20.0));
}

Future<void> showLoadingScreen() async {
  final height = Get.context?.height;
  //Get.closeAllSnackbars();
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
  if (snackBarStatus == SnackbarStatus.CLOSING ||
      snackBarStatus == SnackbarStatus.OPEN ||
      snackBarStatus == SnackbarStatus.OPENING) {
    Get.back(closeOverlays: true);
  } else if (snackBarStatus == SnackbarStatus.CLOSED) {
    Get.back();
  }
}

// void showSimpleSnackBar({
//   required String title,
//   required String body,
// }) {
//   ScaffoldMessenger.of(Get.context!).showSnackBar(
//     SnackBar(
//       content: Text('$title. $body.'),
//       backgroundColor: const Color(0xFF28AADC),
//       behavior: SnackBarBehavior.floating,
//       elevation: 20.0,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//     ),
//   );
// }
//
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
