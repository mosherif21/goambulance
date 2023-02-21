import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

void getToHomePage() => Get.offAll(() => const HomePageScreen());

void authenticatedSetup(AuthType authType) {
  AppInit.currentAuthType.value = AuthType.emailLogin;
}

SnackbarStatus snackBarStatus = SnackbarStatus.CLOSED;

void showFloatingSnackBar(String title, String body, SnackPosition position) {
  Get.snackbar(title, body,
      colorText: Colors.black,
      snackPosition: position,
      snackbarStatus: (snackStatusCallBack) =>
          snackBarStatus = snackStatusCallBack!,
      barBlur: 20.0,
      margin: const EdgeInsets.all(20.0));
}

void showSimpleSnackBar(String title, String body) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text('$title. $body.'),
      backgroundColor: Colors.red,
    ),
  );
}

Future<void> showLoadingScreen() async {
  final height = Get.context?.height;
  Get.dialog(
    AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: WillPopScope(
        onWillPop: () async => false,
        child: SizedBox(
          height: AppInit.notWebMobile ? 812.0 : double.infinity,
          width: AppInit.notWebMobile ? 500.0 : double.infinity,
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
