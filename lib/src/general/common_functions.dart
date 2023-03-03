import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../features/authentication/controllers/login_controller.dart';
import '../features/authentication/controllers/register_controller.dart';
import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

void getToHomePage() => Get.offAll(() => const HomePageScreen());

Future<void> authenticatedSetup() async {
  AppInit.currentAuthType.value = AuthType.emailLogin;
  if (Get.isRegistered<LoginController>()) {
    await Get.delete<LoginController>();
  } else if (Get.isRegistered<RegisterController>()) {
    await Get.delete<RegisterController>();
  }
}

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

void showSimpleSnackBar({
  required String title,
  required String body,
}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text('$title. $body.'),
      backgroundColor: const Color(0xFF28AADC),
      behavior: SnackBarBehavior.floating,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
  );
}

void showAwesomeSnackbar(
    {required String title,
    required String body,
    required ContentType contentType}) {
  ScaffoldMessenger.of(Get.context!)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: body,
          contentType: contentType,
        ),
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
