import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:lottie/lottie.dart';

import '../constants/assets_strings.dart';

void showLoadingScreen() {
  final height = Get.context?.height;
  Get.dialog(
      AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: SizedBox(
          height: AppInit.notWebMobile ? 812.0 : double.infinity,
          width: AppInit.notWebMobile ? 500.0 : double.infinity,
          child: Lottie.asset(kLoadingHeartAnim, height: height! * 0.3),
        ),
      ),
      barrierDismissible: false);
}

void hideLoadingScreen() {
  if (Get.isDialogOpen == true) Get.back();
}
